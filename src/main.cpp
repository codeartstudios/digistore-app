#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtWebview/QtWebView>
#include <QMessageBox>

// User defined headers
#include "dscontroller.h"
#include "requests.h"
#include "permissionmanager.h"
#include "singleinstanceguard.h"

#ifdef STANDALONE_SYSTEM
#include "localserver.h"
#endif

int main(int argc, char *argv[])
{
    QtWebView::initialize();

    QApplication app(argc, argv);

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
    // Create local server instance
    LocalServer lServer{ &dsController };
    if(!lServer.run()) {
        QMessageBox msgBox;
        msgBox.setIcon(QMessageBox::Icon::Critical);
        msgBox.setText(
            QString(QObject::tr("We could not start the server, exitting ...!\n"))
            );
        msgBox.exec();
        return 127;
    }

    // Set default server URL, override where applicable
    dsController.setBaseUrl("http://127.0.0.1:3000");
#else
    // Set default server URL, override where applicable
    dsController.setBaseUrl("https://apps.digisto.app");
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
