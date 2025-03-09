#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtWebview/QtWebView>
#include <QMessageBox>
#include <QObject>

// User defined headers
#include "dscontroller.h"
#include "requests.h"
#include "permissionmanager.h"
#include "singleinstanceguard.h"
#include "globals.h"

#ifdef STANDALONE_SYSTEM
#include "localserver.h"
#endif

int main(int argc, char *argv[])
{
    QtWebView::initialize();        // WebEngine init
    QApplication app(argc, argv);   // App init

#ifdef STANDALONE_SYSTEM
    qApp->setApplicationName("Digisto POS - Standalone");
#else
    qApp->setApplicationName("Digisto POS - Client");
#endif

    // Register message handler
    qInstallMessageHandler(Configurator::messageHandler);

    // Make sure there is no other instance running
    SingleInstanceGuard instance("Digisto");
    if (!instance.tryToRun()) {
        QMessageBox msgBox;
        msgBox.setIcon(QMessageBox::Icon::Critical);
        msgBox.setText(
            QString(QObject::tr("There is another %1 instance running!\n"))
                .arg("Digisto"));
        msgBox.exec();
        return 127;
    }

    // Create the dscontroller instance
    DsController dsController;
    PermissionManager pMan{&dsController, &dsController};

    QQmlApplicationEngine engine;

#ifdef STANDALONE_SYSTEM
    int port = 0;

    if(qEnvironmentVariableIsSet("KG_DIGISTO_LOCAL_PORT")) {
        bool ok;
        int p = qEnvironmentVariableIntValue("KG_DIGISTO_LOCAL_PORT", &ok);

        if(ok) {
            port = p;
            qDebug() << "KG_DIGISTO_LOCAL_PORT = " << port;
        } else {
            port = dsController.findFreePort();
            qDebug() << "KG_DIGISTO_LOCAL_PORT = <INVALID>";
        }
    } else {
        port = dsController.findFreePort();
    }

    QString serverUrl(QString("http://127.0.0.1:%1").arg(port));

    // Create local server instance
    LocalServer lServer{ port, &dsController };
    if(!lServer.run()) {
        QMessageBox msgBox;

        msgBox.setIcon(QMessageBox::Icon::Critical);
        msgBox.setText(
            QString(QObject::tr("We could not start the server, exitting ...!\n"))
            );
        msgBox.exec();
        return 127;
    }

    // Set default server serverUrl, override where applicable
    dsController.setBaseUrl(serverUrl);

    // Create and wire up shared pointer
    QSharedPointer<QThread> localServerThread = QSharedPointer<QThread>::create();
    QObject::connect(localServerThread.data(), &QThread::finished,
                     &lServer, &LocalServer::close);
    QObject::connect(localServerThread.data(), &QThread::finished,
                     localServerThread.data(), &QObject::deleteLater);

    QObject::connect(&app, &QApplication::aboutToQuit, [&]() {
        qDebug() << "Closing PB Thread...";
        localServerThread->quit();  // Exit event loop if used
        localServerThread->wait();  // Wait for cleanup
    });

    // Move local server to thread and start the thread
    lServer.moveToThread(localServerThread.data());
    localServerThread->start();

#else
    if(qEnvironmentVariableIsSet("KG_DIGISTO_ENDPOINT")) {
        bool ok;
        QString url = qEnvironmentVariableIntValue("KG_DIGISTO_ENDPOINT", &ok);

        dsController.setBaseUrl(url);
        qDebug() << "Clinet URL Endpoint Set to: " << url;
    } else {
        // Set default server URL, override where applicable
        dsController.setBaseUrl("https://apps.digisto.app");
    }
#endif

    // Register dscontroller to QML
    engine.rootContext()->setContextProperty("dsController", &dsController);
    engine.rootContext()->setContextProperty("dsPermissionManager", &pMan);

    qmlRegisterType<Requests>("app.digisto.modules", 1, 0, "Requests");
    // qmlRegisterSingletonType(QUrl("qrc:/app/digisto/modules/Theme.qml"), "app.digisto.modules", 1, 0, "Theme");
    // qmlRegisterSingletonType(QUrl("qrc:/app/digisto/modules/IconType.qml"), "app.digisto.modules", 1, 0, "IconType");

    const QUrl url(QStringLiteral("qrc:/ui/Main.qml"));

    engine.addImportPath(":/");

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
