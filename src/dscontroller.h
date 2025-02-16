#ifndef DSCONTROLLER_H
#define DSCONTROLLER_H

#include <QObject>
#include <QGuiApplication>
#include <QSettings>
#include <QVariantMap>
#include <QDateTime>
#include <QJsonDocument>
#include <QJsonObject>
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

    // Bool if user has logged in
    Q_PROPERTY(bool isLoggedIn MEMBER m_isLoggedIn NOTIFY isLoggedInChanged FINAL)

    // Domains
    Q_PROPERTY(QString baseUrl READ baseUrl WRITE setBaseUrl NOTIFY baseUrlChanged FINAL)

    // Application Theme
    Q_PROPERTY(bool isDarkTheme MEMBER m_isDarkTheme NOTIFY isDarkThemeChanged FINAL)
    Q_PROPERTY(bool startWindowMaximized MEMBER m_startWindowMaximized NOTIFY startWindowMaximizedChanged FINAL)

    // Platform properties
    Q_PROPERTY(QString encryptionKey MEMBER m_encryptionKey NOTIFY encryptionKeyChanged FINAL)
    Q_PROPERTY(QString encryptionSalt MEMBER m_encryptionSalt NOTIFY encryptionSaltChanged FINAL)
    Q_PROPERTY(QString platform MEMBER m_platform NOTIFY platformChanged FINAL)

    // Application specific global apps
    Q_PROPERTY(QString workspaceId MEMBER m_workspaceId NOTIFY workspaceIdChanged FINAL)
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
    Q_INVOKABLE void setValueJSON(QString key, QString category, QVariantMap value);

    // Fetches a saved value
    Q_INVOKABLE QVariant getValue(QString key, QString category);

    // Encrypt/decrypt data
    Q_INVOKABLE QString encrypt(QString data);
    Q_INVOKABLE QString decrypt(QString data);

    // Validate the token, if structure is okay and within time limits
    // this does not validate online
    Q_INVOKABLE bool validateToken(const QString& token) const;
    Q_INVOKABLE bool validateToken() const;

    // Base64 Operations (to/fro)
    Q_INVOKABLE QString toBase64(const QString &data);
    Q_INVOKABLE QString fromBase64(const QString &base64Data);

    QString baseUrl() const;
    void setBaseUrl(const QString &newBaseUrl);

public slots:
    void onTokenChanged();
    void onOrganizationChanged();

signals:
    void encryptionKeyChanged();
    void encryptionSaltChanged();
    void platformChanged();

    void workspaceIdChanged();

    void openCashDrawer();

    void loggedUserChanged();

    void tokenChanged();

    void organizationChanged();

    void isDarkThemeChanged();

    void startWindowMaximizedChanged();

    void baseUrlChanged();

    void isLoggedInChanged();

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
    QString m_workspaceId;
    QVariantMap m_loggedUser;
    QString m_token;
    QVariantMap m_organization;
    QString m_baseUrl;
    bool m_isLoggedIn;
};

#endif // DSCONTROLLER_H
