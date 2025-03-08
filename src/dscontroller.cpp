#include "dscontroller.h"
#include <QIcon>
#include "qaesencryption.h"

DsController::DsController(QObject *parent)
    : QObject{parent},
    m_baseUrl(""),
    m_isDarkTheme(false),
    m_startWindowMaximized(false),
    m_platform(QSysInfo::productType()),
    m_isLoggedIn(false)
{
    QFile file(QStringLiteral(":/configs/app-config.json"));
    Q_ASSERT(file.open(QIODevice::ReadOnly));

    QVariantMap configurations=QJsonDocument::fromJson(file.readAll()).toVariant().toMap();

#ifdef STANDALONE_SYSTEM
    qApp->setApplicationName(configurations["title"].toString() + " - Standalone");
#else
    qApp->setApplicationName(configurations["title"].toString() + " - Client");
#endif

    qApp->setApplicationVersion(configurations["versionname"].toString());
    qApp->setApplicationDisplayName(qApp->applicationName() + " v" + configurations["versionname"].toString());
    qApp->setOrganizationName(configurations["organization_name"].toString());
    qApp->setWindowIcon(QIcon(":/assets/imgs/logo.png"));
    qApp->setOrganizationDomain(configurations["organization_domain"].toString());

    m_encryptionKey=configurations["encryption_key"].toString();
    m_encryptionSalt=configurations["encryption_salt"].toString();

    settings = std::make_shared<QSettings>(
        new QSettings(qApp->organizationName(),
                      qApp->applicationDisplayName()
                      )
        );

    // -----------------------------
    // Restore any saved settings  |
    // -----------------------------

    // Get/Restore last log off time
    QVariant logOffTimeStr=getValue("logOffAt","string");
    QDateTime logOffTime = logOffTimeStr.isNull() ?
                               QDateTime::currentDateTimeUtc() : QDateTime::fromString(logOffTimeStr.toString(), "yyyy-MM-ddThh:mm:ss.zzzZ");

    // Get/Restore application theme
    QVariant isDarkTheme=getValue("isDarkTheme","bool");
    m_isDarkTheme = isDarkTheme.isNull() ? false : isDarkTheme.toBool();

    // Get/Restore window start size
    QVariant startWindowMaximized=getValue("startWindowMaximized","bool");
    m_startWindowMaximized = startWindowMaximized.isNull() ? false : startWindowMaximized.toBool();

    // Get/Restore login token
    QVariant token=getValue("token","string");
    m_token= token.isNull() ?
                  "" : validateToken(token.toString()) ?
                                   token.toString() : "";

    // Get/Restore loggedUser JSON
    auto user = getValue("loggedUser", "json");
    m_loggedUser = user.isNull() ? QVariantMap() : user.toMap();

    // Get/User Organization JSON
    auto org = getValue("organization", "json");
    m_organization = org.isNull() ? QVariantMap() : org.toMap();
    // qDebug() << m_organization;

    // -----------------------------
    // Late Connections            |
    // -----------------------------
    connect(this, &DsController::tokenChanged, this, &DsController::onTokenChanged);
    connect(this, &DsController::organizationChanged, this, &DsController::onOrganizationChanged);
}

DsController::~DsController()
{
    setValue("logOffAt", "string", QDateTime::currentDateTimeUtc());
}

void DsController::emitOpenCashDrawer() {
    emit openCashDrawer();
}

void DsController::setValue(QString key,QString category, QVariant value)
{
    settings->setValue(encrypt(key+"/"+category),encrypt(value.toString()));
}

void DsController::setValueJSON(QString key, QString category, QVariantMap value)
{
    QJsonDocument doc(QJsonObject::fromVariantMap(value));
    auto mp = toBase64(doc.toJson());
    settings->setValue(encrypt(key+"/"+category),encrypt(mp));
}

QVariant DsController::getValue(QString key,QString category)
{
    QVariant value=decrypt(settings->value(encrypt(key+"/"+category)).toString());

    auto convert=[&]()
    {
        if(value.isNull() || value.toString().isEmpty() || value.toString().isNull())
        {
            return QVariant();
        }
        else
        {
            if(category == "string")
            {
                return QVariant(value);
            }
            else if(category == "int")
            {
                return QVariant(value.toInt());
            }
            else if(category == "bool")
            {
                return QVariant(value.toBool());
            }
            else if(category == "double")
            {
                return QVariant(value.toDouble());
            }
            else if(category == "json")
            {
                QByteArray jsonb = value.toString().toUtf8();
                QByteArray jsonData = QByteArray::fromBase64(jsonb);
                QJsonDocument doc = QJsonDocument::fromJson(jsonData);
                return QVariant(doc.object().toVariantMap());
            }
            else
            {
                return QVariant(value);
            }
        }
    };

    return convert();
}

QString DsController::encrypt(QString data)
{
    QAESEncryption encryption(QAESEncryption::AES_256, QAESEncryption::ECB);
    QByteArray passwordHash = QCryptographicHash::hash(m_encryptionKey.toStdString().c_str(),QCryptographicHash::Sha512);
    QByteArray saltHash = QCryptographicHash::hash(m_encryptionSalt.toStdString().c_str(),QCryptographicHash::Md5);
    QString output(encryption.encode(data.toStdString().c_str(),passwordHash,saltHash).toBase64());
    return output;
}

QString DsController::decrypt(QString data)
{
    QAESEncryption decryption(QAESEncryption::AES_256, QAESEncryption::ECB);
    QByteArray passwordHash = QCryptographicHash::hash(m_encryptionKey.toStdString().c_str(),QCryptographicHash::Sha512);
    QByteArray saltHash = QCryptographicHash::hash(m_encryptionSalt.toStdString().c_str(),QCryptographicHash::Md5);
    QByteArray decodeText = decryption.decode(QByteArray::fromBase64(data.toStdString().c_str()), passwordHash, saltHash);
    QString output = QString(decryption.removePadding(decodeText));
    return output;
}

bool DsController::validateToken(const QString &token) const
{
    auto parts = token.split(".");

    if (parts.size() != 3) {
        return false;
    }

    QByteArray payload = base64UrlDecode(parts[1]);
    QJsonParseError parseError;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(payload, &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        qWarning() << "Failed to parse JSON payload:" << parseError.errorString();
        return false;
    }

    return jsonDoc["exp"].toInteger() > QDateTime::currentSecsSinceEpoch();
}

bool DsController::validateToken() const
{
    return validateToken(m_token);
}

void DsController::onTokenChanged()
{
    setValue("token", "string", m_token);
}

void DsController::onOrganizationChanged()
{
    // qDebug() << m_organization;
    setValueJSON("organization", "json", m_organization);

    // Update Workspace ID as well, emitting changed signal
    m_workspaceId = m_organization.isEmpty() ? "" : m_organization["id"].toString();
    emit workspaceIdChanged();
}

QByteArray DsController::base64UrlDecode(const QString &base64Url) const {
    QString base64 = base64Url;
    base64.replace('-', '+').replace('_', '/');

    while (base64.length() % 4 != 0) {
        base64.append('=');
    }

    return QByteArray::fromBase64(base64.toUtf8());
}

QString DsController::toBase64(const QString &data)
{
    return data.toUtf8().toBase64();
}

QString DsController::fromBase64(const QString &base64Data)
{
    QByteArray data = QByteArray::fromBase64(base64Data.toUtf8());
    return QString(data);
}

QString DsController::baseUrl() const
{
    return m_baseUrl;
}

void DsController::setBaseUrl(const QString &newBaseUrl)
{
    if (m_baseUrl == newBaseUrl)
        return;
    m_baseUrl = newBaseUrl;
    emit baseUrlChanged();
}

QVariantMap DsController::organization() const
{
    return m_organization;
}

void DsController::setOrganization(const QVariantMap &newOrganization)
{
    m_organization = newOrganization;
    emit organizationChanged();
}

QVariantMap DsController::loggedUser() const
{
    return m_loggedUser;
}

void DsController::setLoggedUser(const QVariantMap &newLoggedUser)
{
    m_loggedUser = newLoggedUser;
    emit loggedUserChanged();
}

bool DsController::extractFileFromQRC(const QString &resourcePath, const QString &destination) {
    QFile file(resourcePath);
    if (!file.exists()) {
        qWarning() << "Resource not found:" << resourcePath;
        return false;
    }

    // Ensure the target directory exists
    QDir dir;
    dir.mkpath(QFileInfo(destination).absolutePath());

    if (file.copy(destination)) {
        qDebug() << "Extracted:" << destination;
        return true;
    } else {
        qWarning() << "Failed to extract" << resourcePath;
        return false;
    }
}
