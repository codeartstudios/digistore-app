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

    // Application specific global apps
    Q_PROPERTY(QString organizationID MEMBER m_organizationID NOTIFY organizationIDChanged FINAL)

    //
    Q_INVOKABLE void emitOpenCashDrawer();
signals:
    void encryptionKeyChanged();
    void encryptionSaltChanged();
    void platformChanged();

    void organizationIDChanged();

    void openCashDrawer();

private:
    std::shared_ptr<QSettings> settings;
    QString m_encryptionKey;
    QString m_encryptionSalt;
    QString m_platform;
    QString m_organizationID;
};

#endif // DSCONTROLLER_H
