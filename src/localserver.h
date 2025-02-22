#ifndef LOCALSERVER_H
#define LOCALSERVER_H

#include <QObject>

class LocalServer : public QObject
{
    Q_OBJECT
public:
    explicit LocalServer(QObject *parent = nullptr);

    // Location for data storage
    Q_PROPERTY(QString appDataDir READ appDataDir WRITE setAppDataDir NOTIFY appDataDirChanged FINAL)

    // Flag for whether server is running locally
    Q_PROPERTY(bool isServerRunning READ isServerRunning WRITE setIsServerRunning NOTIFY isServerRunningChanged FINAL)

signals:
};

#endif // LOCALSERVER_H
