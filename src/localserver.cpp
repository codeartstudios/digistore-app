#include "localserver.h"
#include <QDebug>
#include <QStandardPaths>
#include <QSharedPointer>

LocalServer::LocalServer(int port, DsController* dsController, QObject *parent)
    : QObject{parent},
    m_dsController(dsController),
    m_port(port),
    m_pbRunner(new QProcess(this)),
    m_pocketbaseExec(QString("%1/api/pocketbase").arg(QCoreApplication::applicationDirPath()))
{
    QString localAppDataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);

    setPbHooksDir(QString("%1/hooks").arg(localAppDataDir));
    setPbDataDir(QString("%1/data").arg(localAppDataDir));
    setPbMigrationsDir(QString("%1/migrations").arg(localAppDataDir));
    setPbPublicDir(QString("%1/public").arg(localAppDataDir));

    // Delete existing folders ...
    deleteFolder(m_pbHooksDir);
    deleteFolder(m_pbMigrationsDir);

    // Extract hooks from QRC
    m_dsController->extractFileFromQRC(":/pb/hooks/checkout.pb.js", m_pbHooksDir + "/checkout.pb.js");
    m_dsController->extractFileFromQRC(":/pb/hooks/dashboard.pb.js", m_pbHooksDir + "/dashboard.pb.js");
    m_dsController->extractFileFromQRC(":/pb/hooks/main.pb.js", m_pbHooksDir + "/main.pb.js");
    m_dsController->extractFileFromQRC(":/pb/hooks/organization.pb.js", m_pbHooksDir + "/organization.pb.js");
    m_dsController->extractFileFromQRC(":/pb/hooks/supply.pb.js", m_pbHooksDir + "/supply.pb.js");
    m_dsController->extractFileFromQRC(":/pb/hooks/utils.js", m_pbHooksDir + "/utils.js");

    // Extract Migration Files
    m_dsController->extractFileFromQRC(":/pb/migrations/collections_snapshot.js", m_pbMigrationsDir + "/collections_snapshot.js");
    m_dsController->extractFileFromQRC(":/pb/migrations/admin.pb.js", m_pbMigrationsDir + "/admin.js");

    // Signal connections
    connect(m_pbRunner, &QProcess::readyReadStandardOutput, this, &LocalServer::onReadyReadOutput);
    connect(m_pbRunner, &QProcess::readyReadStandardError, this, &LocalServer::onReadyReadError);
}

LocalServer::~LocalServer() {
    close();
}

bool LocalServer::run()
{
    return startPocketBaseServer();
}

QString LocalServer::pbHooksDir() const
{
    return m_pbHooksDir;
}

void LocalServer::setPbHooksDir(const QString &newPbHooksDir)
{
    if (m_pbHooksDir == newPbHooksDir)
        return;
    m_pbHooksDir = newPbHooksDir;
    emit pbHooksDirChanged();
}

QString LocalServer::pbDataDir() const
{
    return m_pbDataDir;
}

void LocalServer::setPbDataDir(const QString &newPbDataDir)
{
    if (m_pbDataDir == newPbDataDir)
        return;
    m_pbDataDir = newPbDataDir;
    emit pbDataDirChanged();
}

QString LocalServer::pbMigrationsDir() const
{
    return m_pbMigrationsDir;
}

void LocalServer::setPbMigrationsDir(const QString &newPbMigrationsDir)
{
    if (m_pbMigrationsDir == newPbMigrationsDir)
        return;
    m_pbMigrationsDir = newPbMigrationsDir;
    emit pbMigrationsDirChanged();
}

QString LocalServer::pbPublicDir() const
{
    return m_pbPublicDir;
}

void LocalServer::setPbPublicDir(const QString &newPbPublicDir)
{
    if (m_pbPublicDir == newPbPublicDir)
        return;
    m_pbPublicDir = newPbPublicDir;
    emit pbPublicDirChanged();
}

bool LocalServer::isServerRunning() const
{
    return m_isServerRunning;
}

void LocalServer::setIsServerRunning(bool newIsServerRunning)
{
    if (m_isServerRunning == newIsServerRunning)
        return;
    m_isServerRunning = newIsServerRunning;
    emit isServerRunningChanged();
}

int LocalServer::port() const
{
    return m_port;
}

void LocalServer::setPort(int newPort)
{
    if (m_port == newPort)
        return;
    m_port = newPort;
    emit portChanged();
}

void LocalServer::close() {
    if(m_pbRunner->isOpen())
        m_pbRunner->close();
}

void LocalServer::onReadyReadOutput()
{
    while(m_pbRunner->canReadLine()) {
        auto d = m_pbRunner->readLine();
        qDebug() << "[PB STDOUT] " << d.trimmed().data();
    }
}

void LocalServer::onReadyReadError()
{
    while(m_pbRunner->canReadLine()) {
        auto d = m_pbRunner->readLine();
        qDebug() << "PB [STDERR] " << d.trimmed().data();
    }
}

void LocalServer::loadCollectionSchema()
{
    QStringList args;
    args << "migrate up";
    args << "--hooksDir"        << m_pbHooksDir;
    args << "--migrationsDir"   << m_pbMigrationsDir;
    args << "--dir"             << m_pbDataDir;
    args << "--automigrate";

    QSharedPointer<QProcess> migrator =
        QSharedPointer<QProcess>(new QProcess, &QObject::deleteLater);
    migrator->start(m_pocketbaseExec, args);

    if(!migrator->waitForStarted()) {
        qDebug() << "Failed to apply migrations ...";
    }
}

bool LocalServer::startPocketBaseServer()
{
    QStringList args;
    args << "serve";
    args << QString("--http=127.0.0.1:%1").arg(m_port);
    args << "--hooksDir"        << m_pbHooksDir;
    args << "--migrationsDir"   << m_pbMigrationsDir;
    args << "--dir"             << m_pbDataDir;
    args << "--publicDir"       << m_pbPublicDir;
    args << "--automigrate";

#ifdef QT_DEBUG
    args << "--dev";
    args << "--hooksWatch";
#endif

    m_pbRunner->start(m_pocketbaseExec, args);

    // Ensure server is running ...
    if(!m_pbRunner->waitForStarted()) {
        qDebug() << "Could not start server ...";
        setIsServerRunning(false);
        return false;
    }

    setIsServerRunning(true);
    return true;
}

bool LocalServer::deleteFolder(const QString &folderPath) {
    QDir dir(folderPath);

    if (!dir.exists()) {
        qWarning() << "Folder does not exist:" << folderPath;
        return false;
    }

    if (dir.removeRecursively()) {
        qDebug() << "Deleted folder:" << folderPath;
        return true;
    } else {
        qWarning() << "Failed to delete folder:" << folderPath;
        return false;
    }
}
