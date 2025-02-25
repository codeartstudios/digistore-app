#include "permissionmanager.h"

#include <QVariantMap>
#include <QFile>

PermissionManager::PermissionManager(DsController *dsController, QObject *parent)
    : QObject{parent},
    m_dsController(dsController)
{
    // Load permission template from the json file
    QFile file(QStringLiteral("qrc:/configs/permissions-templ.json"));
    Q_ASSERT(file.open(QIODevice::ReadOnly));

    // Create QVariantMap out of the template json
    m_permissionTemplate = QJsonDocument::fromJson(file.readAll()).toVariant().toMap();
}

bool PermissionManager::hasPermission(const QString &module, const QString &action)
{
    // Null check organization object, return false
    if(!m_dsController) return false;

    // Get organization object
    const auto user = m_dsController->loggedUser();
    if(user.isEmpty())
        return false;

    // Get all acceptable roles from the template
    const auto templRoles = m_permissionTemplate.keys();
    qDebug() << templRoles;

    const auto role = user.value("role").toString();
    if(!templRoles.contains(role.trimmed().toLower()))
        return false;

    auto p = m_permissionTemplate.value(role.trimmed().toLower()).toMap();
    if(p.value(module.toLower()).toList().contains(action.toLower()))
        return true;

    const auto overrides = user.value("overrides").toMap();
    p = overrides.value(role.trimmed().toLower()).toMap();
    if(p.value(module.toLower()).toList().contains(action.toLower()))
        return true;

    return false;
}

QVariantMap PermissionManager::permissionTemplate() const
{
    return m_permissionTemplate;
}
