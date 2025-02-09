#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtWebview/QtWebView>

// User defined headers
#include "dscontroller.h"
#include "requests.h"

int main(int argc, char *argv[])
{
    QtWebView::initialize();

    QGuiApplication app(argc, argv);

    // Create the dscontroller instance
    DsController dsController;

    // Set default server URL, override where applicable
    dsController.setBaseUrl("http://127.0.0.1:8090");

    QQmlApplicationEngine engine;

    // Register dscontroller to QML
    engine.rootContext()->setContextProperty("dsController", &dsController);

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
