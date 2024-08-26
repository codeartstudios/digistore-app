#ifndef DSCONTROLLER_H
#define DSCONTROLLER_H

#include <QObject>
#include <QGuiApplication>
#include <QSettings>
#include <QVariantMap>
#include <QJsonDocument>
#include <QFile>
#include <memory>
#include <QSysInfo>

class DsController : public QObject
{
    Q_OBJECT
public:
    explicit DsController(QObject *parent = nullptr);

    Q_PROPERTY(QString encryptionKey MEMBER m_encryptionKey NOTIFY encryptionKeyChanged FINAL)
    Q_PROPERTY(QString encryptionSalt MEMBER m_encryptionSalt NOTIFY encryptionSaltChanged FINAL)
    Q_PROPERTY(QString platform MEMBER m_platform NOTIFY platformChanged FINAL)

signals:
    void encryptionKeyChanged();
    void encryptionSaltChanged();
    void platformChanged();

private:
    std::shared_ptr<QSettings> settings;
    QString m_encryptionKey;
    QString m_encryptionSalt;
    QString m_platform;
};

#endif // DSCONTROLLER_H
