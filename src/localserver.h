#ifndef LOCALSERVER_H
#define LOCALSERVER_H

#include <QObject>
#include <QProcess>

#include "dscontroller.h"

class LocalServer : public QObject
{
    Q_OBJECT
public:
    explicit LocalServer(int port, DsController* dsController, QObject *parent = nullptr);
    ~LocalServer();

    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged FINAL)

    // Location for data storage
    Q_PROPERTY(QString pbHooksDir READ pbHooksDir WRITE setPbHooksDir NOTIFY pbHooksDirChanged FINAL)
    Q_PROPERTY(QString pbDataDir READ pbDataDir WRITE setPbDataDir NOTIFY pbDataDirChanged FINAL)
    Q_PROPERTY(QString pbMigrationsDir READ pbMigrationsDir WRITE setPbMigrationsDir NOTIFY pbMigrationsDirChanged FINAL)
    Q_PROPERTY(QString pbPublicDir READ pbPublicDir WRITE setPbPublicDir NOTIFY pbPublicDirChanged FINAL)

    // Flag for whether server is running locally
    Q_PROPERTY(bool isServerRunning READ isServerRunning WRITE setIsServerRunning NOTIFY isServerRunningChanged FINAL)

    bool run();

    QString pbHooksDir() const;
    void setPbHooksDir(const QString &newPbHooksDir);

    QString pbDataDir() const;
    void setPbDataDir(const QString &newPbDataDir);

    QString pbMigrationsDir() const;
    void setPbMigrationsDir(const QString &newPbMigrationsDir);

    QString pbPublicDir() const;
    void setPbPublicDir(const QString &newPbPublicDir);

    bool isServerRunning() const;
    void setIsServerRunning(bool newIsServerRunning);

    int port() const;
    void setPort(int newPort);

public slots:
    void close();

signals:
    void pbHooksDirChanged();
    void pbDataDirChanged();
    void pbMigrationsDirChanged();
    void pbPublicDirChanged();

    void isServerRunningChanged();
    void portChanged();

public slots:
    void onReadyReadOutput();
    void onReadyReadError();

private:
    void loadCollectionSchema();
    bool startPocketBaseServer();
    bool deleteFolder(const QString &folderPath);

private:
    DsController* m_dsController;

    QString m_pbHooksDir;
    QString m_pbDataDir;
    QString m_pbMigrationsDir;
    QString m_pbPublicDir;
    bool m_isServerRunning;

    QProcess *m_pbRunner;
    int m_port;
    QString m_pocketbaseExec;
};

#endif // LOCALSERVER_H
