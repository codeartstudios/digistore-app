#include "dscontroller.h"

#include <QIcon>

DsController::DsController(QObject *parent)
    : QObject{parent}, m_platform(QSysInfo::productType())
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

    settings = std::make_shared<QSettings>(new QSettings(qApp->organizationName(),qApp->applicationDisplayName()));

}
