#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

// User defined headers
#include "dscontroller.h"
#include "requests.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    // Create the dscontroller instance
    DsController dsController;

    QQmlApplicationEngine engine;

    // Register dscontroller to QML
    engine.rootContext()->setContextProperty("dsController", &dsController);

    qmlRegisterType<Requests>("app.digisto.modules", 1, 0, "Requests");

    const QUrl url(QStringLiteral("qrc:/ui/Main.qml"));

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
