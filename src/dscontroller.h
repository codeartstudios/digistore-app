#ifndef DSCONTROLLER_H
#define DSCONTROLLER_H

#include <QObject>
#include <QGuiApplication>
#include <QSettings>
#include <QVariantMap>
#include <QDateTime>
#include <QJsonDocument>
#include <QFile>
#include <memory>
#include <QSysInfo>
#include <QCryptographicHash>

class DsController : public QObject
{
    Q_OBJECT
public:
    explicit DsController(QObject *parent = nullptr);
    ~DsController();

    // Application Theme
    Q_PROPERTY(bool isDarkTheme MEMBER m_isDarkTheme NOTIFY isDarkThemeChanged FINAL)
    Q_PROPERTY(bool startWindowMaximized MEMBER m_startWindowMaximized NOTIFY startWindowMaximizedChanged FINAL)

    // Platform properties
    Q_PROPERTY(QString encryptionKey MEMBER m_encryptionKey NOTIFY encryptionKeyChanged FINAL)
    Q_PROPERTY(QString encryptionSalt MEMBER m_encryptionSalt NOTIFY encryptionSaltChanged FINAL)
    Q_PROPERTY(QString platform MEMBER m_platform NOTIFY platformChanged FINAL)

    // Application specific global apps
    Q_PROPERTY(QString organizationID MEMBER m_organizationID NOTIFY organizationIDChanged FINAL)
    Q_PROPERTY(QVariantMap loggedUser MEMBER m_loggedUser NOTIFY loggedUserChanged FINAL)
    Q_PROPERTY(QString token MEMBER m_token NOTIFY tokenChanged FINAL)
    Q_PROPERTY(QVariantMap organization MEMBER m_organization NOTIFY organizationChanged FINAL)

    // ------------------------------------------ //
    //          DsController Invokables           //
    // ------------------------------------------ //

    // Invoke this function to emit the open drawer
    // signal. This is intended to open the cash drawer
    // if any is connected/confirgured.
    Q_INVOKABLE void emitOpenCashDrawer();

    // Set new value to be stored
    Q_INVOKABLE void setValue(QString key, QString category, QVariant value);

    // Fetches a saved value
    Q_INVOKABLE QVariant getValue(QString key, QString category);

    // Encrypt/decrypt data
    Q_INVOKABLE QString encrypt(QString data);
    Q_INVOKABLE QString decrypt(QString data);

    // Validate the token, if structure is okay and within time limits
    // this does not validate online
    Q_INVOKABLE bool validateToken(const QString& token) const;
    Q_INVOKABLE bool validateToken() const;

public slots:
    void onTokenChanged();

signals:
    void encryptionKeyChanged();
    void encryptionSaltChanged();
    void platformChanged();

    void organizationIDChanged();

    void openCashDrawer();

    void loggedUserChanged();

    void tokenChanged();

    void organizationChanged();

    void isDarkThemeChanged();

    void startWindowMaximizedChanged();

private:
    // -------------------------------- |
    //  METHODS
    // -------------------------------- |
    QByteArray base64UrlDecode(const QString& base64Url) const;


    // -------------------------------- |
    //  Class Member Variables
    // -------------------------------- |
    bool m_isDarkTheme;
    bool m_startWindowMaximized;
    std::shared_ptr<QSettings> settings;
    QString m_encryptionKey;
    QString m_encryptionSalt;
    QString m_platform;
    QString m_organizationID;
    QVariantMap m_loggedUser;
    QString m_token;
    QVariantMap m_organization;
};

#endif // DSCONTROLLER_H
