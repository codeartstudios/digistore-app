#include "localserver.h"
#include <QDebug>
#include <QStandardPaths>

LocalServer::LocalServer(DsController* dsController, QObject *parent)
    : QObject{parent},
    m_dsController(dsController),
    m_port(15234)
{
    QString localAppDataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);

    qDebug() << localAppDataDir;

    setPbHooksDir(QString("%1/hooks").arg(localAppDataDir));
    setPbDataDir(QString("%1/data").arg(localAppDataDir));
    setPbMigrationsDir(QString("%1/migrations").arg(localAppDataDir));
    setPbPublicDir(QString("%1/public").arg(localAppDataDir));

    // Extract hooks from QRC
    m_dsController->extractFileFromQRC(":/pb/hooks/checkout.pb.js", m_pbHooksDir + "/checkout.pb.js");
    m_dsController->extractFileFromQRC(":/pb/hooks/dashboard.pb.js", m_pbHooksDir + "/dashboard.pb.js");
    m_dsController->extractFileFromQRC(":/pb/hooks/main.pb.js", m_pbHooksDir + "/main.pb.js");
    m_dsController->extractFileFromQRC(":/pb/hooks/organization.pb.js", m_pbHooksDir + "/organization.pb.js");
    m_dsController->extractFileFromQRC(":/pb/hooks/supply.pb.js", m_pbHooksDir + "/supply.pb.js");
    m_dsController->extractFileFromQRC(":/pb/hooks/utils.js", m_pbHooksDir + "/utils.js");

    // Get executable path for pocketbase
    QString pbExec = QString("%1/api/pocketbase").arg(QCoreApplication::applicationDirPath());

    QStringList args;
    // .\bin\win\pocketbase.exe serve 3000"
    args << "serve";
    args << QString("--http=\"127.0.0.1:%1\"").arg(m_port);
    args << "--hooksDir" << m_pbHooksDir;
    args << "--migrationsDir" << m_pbMigrationsDir;
    args << "--dir" << m_pbDataDir;
    args << "--publicDir" << m_pbPublicDir;
    args << "--automigrate";

#ifdef QT_DEBUG
    args << "--dev --hooksWatch";
#endif

    m_pbRunner = new QProcess(this);
    m_pbRunner->start(pbExec, args);
}

bool LocalServer::run()
{
    // Ensure server is running ...
    if(!m_pbRunner->waitForStarted()) {
        qDebug() << "Could not start server ...";
        return false;
    }

    return true;
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
