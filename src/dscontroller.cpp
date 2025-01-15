#include "dscontroller.h"
#include <QIcon>
#include "qaesencryption.h"

DsController::DsController(QObject *parent)
    : QObject{parent},
    m_isDarkTheme(false),
    m_startWindowMaximized(false),
    m_platform(QSysInfo::productType())
{
    QFile file(QStringLiteral(":/ui/config.json"));
    Q_ASSERT(file.open(QIODevice::ReadOnly));

    QVariantMap configurations=QJsonDocument::fromJson(file.readAll()).toVariant().toMap();

    qApp->setApplicationName(configurations["title"].toString());
    qApp->setApplicationVersion(configurations["versionname"].toString());
    qApp->setApplicationDisplayName(configurations["title"].toString() + " v" + configurations["versionname"].toString());
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

    // -----------------------------
    // Late Connections            |
    // -----------------------------
    connect(this, &DsController::tokenChanged, this, &DsController::onTokenChanged);
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
    qDebug() << "Token: " << token;

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
    // qDebug() << "Setting & Saving new token: " << m_token;
    setValue("token", "string", m_token);
}

QByteArray DsController::base64UrlDecode(const QString &base64Url) const {
    QString base64 = base64Url;
    base64.replace('-', '+').replace('_', '/');

    while (base64.length() % 4 != 0) {
        base64.append('=');
    }

    return QByteArray::fromBase64(base64.toUtf8());
}
