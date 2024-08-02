#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

// User defined headers
#include "dscontroller.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Create the dscontroller instance
    DsController dsController;

    QQmlApplicationEngine engine;

    // Register dscontroller to QML
    engine.rootContext()->setContextProperty("dsController", &dsController);

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
