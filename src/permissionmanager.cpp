#include "permissionmanager.h"

#include <QVariantMap>
#include <QFile>

PermissionManager::PermissionManager(DsController *dsController, QObject *parent)
    : QObject { parent },
    m_dsController(dsController)
{
    // Load permission template from the json file
    QFile file(QStringLiteral(":/configs/permissions-templ.json"));
    Q_ASSERT(file.open(QIODevice::ReadOnly));

    // Create QVariantMap out of the template json
    m_permissionTemplate =
        QJsonDocument::fromJson(file.readAll()).toVariant().toMap();

    // Connect permission checks for changing user details
    connect(dsController, &DsController::loggedUserChanged,
            this, &PermissionManager::checkPermissions);
}

bool PermissionManager::hasPermission(const QString &module, const QString &action)
{
    if(checkIfUserIsNull())
        return false;

    // Get all acceptable roles from the template
    const auto templRoles = m_permissionTemplate.keys();

    const auto user = m_dsController->loggedUser();
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

bool PermissionManager::checkIfUserIsNull() {
    // Null check organization object, return true (its null)
    if(!m_dsController)
        return true;

    // Get organization object
    const auto user = m_dsController->loggedUser();
    if(user.isEmpty())
        return true;

    return false;
}

bool PermissionManager::hasOrganizationPermission(const QString &action) {
    return hasPermission("organization", action);
}

bool PermissionManager::hasUserAccountsPermission(const QString &action) {
    return hasPermission("user_accounts", action);
}

bool PermissionManager::hasSuppliersPermission(const QString &action) {
    return hasPermission("suppliers", action);
}

bool PermissionManager::hasSupplyPermission(const QString &action) {
    return hasPermission("supply", action);
}

bool PermissionManager::hasInventoryPermission(const QString &action) {
    return hasPermission("inventory", action);
}

bool PermissionManager::hasSalesPermission(const QString &action) {
    return hasPermission("sales", action);
}

QVariantMap PermissionManager::permissionTemplate() const
{
    return m_permissionTemplate;
}

bool PermissionManager::canViewInventory() const
{
    return m_canViewInventory;
}

void PermissionManager::setCanViewInventory(bool newCanViewInventory)
{
    if (m_canViewInventory == newCanViewInventory)
        return;
    m_canViewInventory = newCanViewInventory;
    emit canViewInventoryChanged();
}

bool PermissionManager::canCreateInventory() const
{
    return m_canCreateInventory;
}

void PermissionManager::setCanCreateInventory(bool newCanCreateInventory)
{
    if (m_canCreateInventory == newCanCreateInventory)
        return;
    m_canCreateInventory = newCanCreateInventory;
    emit canCreateInventoryChanged();
}

bool PermissionManager::canUpdateInventory() const
{
    return m_canUpdateInventory;
}

void PermissionManager::setCanUpdateInventory(bool newCanUpdateInventory)
{
    if (m_canUpdateInventory == newCanUpdateInventory)
        return;
    m_canUpdateInventory = newCanUpdateInventory;
    emit canUpdateInventoryChanged();
}

bool PermissionManager::canDeleteInventory() const
{
    return m_canDeleteInventory;
}

void PermissionManager::setCanDeleteInventory(bool newCanDeleteInventory)
{
    if (m_canDeleteInventory == newCanDeleteInventory)
        return;
    m_canDeleteInventory = newCanDeleteInventory;
    emit canDeleteInventoryChanged();
}

void PermissionManager::checkPermissions()
{
    qDebug() << "Checking permissions, user change ...";

    // Check if logged in user is an admin
    setIsAdmin(
        checkIfUserIsNull() && // If user is valid, false otherwise
        m_dsController->loggedUser().value("role").toString() == "admin"
        );

    // Update inventory permissions
    setCanViewInventory(hasInventoryPermission("view"));
    setCanCreateInventory(hasInventoryPermission("create"));
    setCanUpdateInventory(hasInventoryPermission("update"));
    setCanDeleteInventory(hasInventoryPermission("delete"));

    // Update supply permissions
    setCanViewSupply(hasSupplyPermission("view"));
    setCanCreateSupply(hasSupplyPermission("create"));
    setCanUpdateSupply(hasSupplyPermission("update"));
    setCanDeleteSupply(hasSupplyPermission("delete"));

    // Update suppliers permissions
    setCanViewSuppliers(hasSuppliersPermission("view"));
    setCanCreateSuppliers(hasSuppliersPermission("create"));
    setCanUpdateSuppliers(hasSuppliersPermission("update"));
    setCanDeleteSuppliers(hasSuppliersPermission("delete"));

    // Update sales permissions
    setCanViewSales(hasSalesPermission("view"));
    setCanCreateSales(hasSalesPermission("create"));
    setCanUpdateSales(hasSalesPermission("update"));
    setCanDeleteSales(hasSalesPermission("delete"));

    // Update organization permissions
    setCanViewOrganization(hasOrganizationPermission("view"));
    setCanCreateOrganization(hasOrganizationPermission("create"));
    setCanUpdateOrganization(hasOrganizationPermission("update"));
    setCanDeleteOrganization(hasOrganizationPermission("delete"));

    // Update user accounts permissions
    setCanViewUserAccounts(hasUserAccountsPermission("view"));
    setCanCreateUserAccounts(hasUserAccountsPermission("create"));
    setCanUpdateUserAccounts(hasUserAccountsPermission("update"));
    setCanDeleteUserAccounts(hasUserAccountsPermission("delete"));
}

bool PermissionManager::canViewSupply() const
{
    return m_canViewSupply;
}

void PermissionManager::setCanViewSupply(bool newCanViewSupply)
{
    if (m_canViewSupply == newCanViewSupply)
        return;
    m_canViewSupply = newCanViewSupply;
    emit canViewSupplyChanged();
}

bool PermissionManager::canCreateSupply() const
{
    return m_canCreateSupply;
}

void PermissionManager::setCanCreateSupply(bool newCanCreateSupply)
{
    if (m_canCreateSupply == newCanCreateSupply)
        return;
    m_canCreateSupply = newCanCreateSupply;
    emit canCreateSupplyChanged();
}

bool PermissionManager::canUpdateSupply() const
{
    return m_canUpdateSupply;
}

void PermissionManager::setCanUpdateSupply(bool newCanUpdateSupply)
{
    if (m_canUpdateSupply == newCanUpdateSupply)
        return;
    m_canUpdateSupply = newCanUpdateSupply;
    emit canUpdateSupplyChanged();
}

bool PermissionManager::canDeleteSupply() const
{
    return m_canDeleteSupply;
}

void PermissionManager::setCanDeleteSupply(bool newCanDeleteSupply)
{
    if (m_canDeleteSupply == newCanDeleteSupply)
        return;
    m_canDeleteSupply = newCanDeleteSupply;
    emit canDeleteSupplyChanged();
}

bool PermissionManager::canViewSuppliers() const
{
    return m_canViewSuppliers;
}

void PermissionManager::setCanViewSuppliers(bool newCanViewSuppliers)
{
    if (m_canViewSuppliers == newCanViewSuppliers)
        return;
    m_canViewSuppliers = newCanViewSuppliers;
    emit canViewSuppliersChanged();
}

bool PermissionManager::canCreateSuppliers() const
{
    return m_canCreateSuppliers;
}

void PermissionManager::setCanCreateSuppliers(bool newCanCreateSuppliers)
{
    if (m_canCreateSuppliers == newCanCreateSuppliers)
        return;
    m_canCreateSuppliers = newCanCreateSuppliers;
    emit canCreateSuppliersChanged();
}

bool PermissionManager::canUpdateSuppliers() const
{
    return m_canUpdateSuppliers;
}

void PermissionManager::setCanUpdateSuppliers(bool newCanUpdateSuppliers)
{
    if (m_canUpdateSuppliers == newCanUpdateSuppliers)
        return;
    m_canUpdateSuppliers = newCanUpdateSuppliers;
    emit canUpdateSuppliersChanged();
}

bool PermissionManager::canDeleteSuppliers() const
{
    return m_canDeleteSuppliers;
}

void PermissionManager::setCanDeleteSuppliers(bool newCanDeleteSuppliers)
{
    if (m_canDeleteSuppliers == newCanDeleteSuppliers)
        return;
    m_canDeleteSuppliers = newCanDeleteSuppliers;
    emit canDeleteSuppliersChanged();
}

bool PermissionManager::canViewSales() const
{
    return m_canViewSales;
}

void PermissionManager::setCanViewSales(bool newCanViewSales)
{
    if (m_canViewSales == newCanViewSales)
        return;
    m_canViewSales = newCanViewSales;
    emit canViewSalesChanged();
}

bool PermissionManager::canCreateSales() const
{
    return m_canCreateSales;
}

void PermissionManager::setCanCreateSales(bool newCanCreateSales)
{
    if (m_canCreateSales == newCanCreateSales)
        return;
    m_canCreateSales = newCanCreateSales;
    emit canCreateSalesChanged();
}

bool PermissionManager::canUpdateSales() const
{
    return m_canUpdateSales;
}

void PermissionManager::setCanUpdateSales(bool newCanUpdateSales)
{
    if (m_canUpdateSales == newCanUpdateSales)
        return;
    m_canUpdateSales = newCanUpdateSales;
    emit canUpdateSalesChanged();
}

bool PermissionManager::canDeleteSales() const
{
    return m_canDeleteSales;
}

void PermissionManager::setCanDeleteSales(bool newCanDeleteSales)
{
    if (m_canDeleteSales == newCanDeleteSales)
        return;
    m_canDeleteSales = newCanDeleteSales;
    emit canDeleteSalesChanged();
}

bool PermissionManager::canViewOrganization() const
{
    return m_canViewOrganization;
}

void PermissionManager::setCanViewOrganization(bool newCanViewOrganization)
{
    if (m_canViewOrganization == newCanViewOrganization)
        return;
    m_canViewOrganization = newCanViewOrganization;
    emit canViewOrganizationChanged();
}

bool PermissionManager::canCreateOrganization() const
{
    return m_canCreateOrganization;
}

void PermissionManager::setCanCreateOrganization(bool newCanCreateOrganization)
{
    if (m_canCreateOrganization == newCanCreateOrganization)
        return;
    m_canCreateOrganization = newCanCreateOrganization;
    emit canCreateOrganizationChanged();
}

bool PermissionManager::canUpdateOrganization() const
{
    return m_canUpdateOrganization;
}

void PermissionManager::setCanUpdateOrganization(bool newCanUpdateOrganization)
{
    if (m_canUpdateOrganization == newCanUpdateOrganization)
        return;
    m_canUpdateOrganization = newCanUpdateOrganization;
    emit canUpdateOrganizationChanged();
}

bool PermissionManager::canDeleteOrganization() const
{
    return m_canDeleteOrganization;
}

void PermissionManager::setCanDeleteOrganization(bool newCanDeleteOrganization)
{
    if (m_canDeleteOrganization == newCanDeleteOrganization)
        return;
    m_canDeleteOrganization = newCanDeleteOrganization;
    emit canDeleteOrganizationChanged();
}

bool PermissionManager::canViewUserAccounts() const
{
    return m_canViewUserAccounts;
}

void PermissionManager::setCanViewUserAccounts(bool newCanViewUserAccounts)
{
    if (m_canViewUserAccounts == newCanViewUserAccounts)
        return;
    m_canViewUserAccounts = newCanViewUserAccounts;
    emit canViewUserAccountsChanged();
}

bool PermissionManager::canCreateUserAccounts() const
{
    return m_canCreateUserAccounts;
}

void PermissionManager::setCanCreateUserAccounts(bool newCanCreateUserAccounts)
{
    if (m_canCreateUserAccounts == newCanCreateUserAccounts)
        return;
    m_canCreateUserAccounts = newCanCreateUserAccounts;
    emit canCreateUserAccountsChanged();
}

bool PermissionManager::canUpdateUserAccounts() const
{
    return m_canUpdateUserAccounts;
}

void PermissionManager::setCanUpdateUserAccounts(bool newCanUpdateUserAccounts)
{
    if (m_canUpdateUserAccounts == newCanUpdateUserAccounts)
        return;
    m_canUpdateUserAccounts = newCanUpdateUserAccounts;
    emit canUpdateUserAccountsChanged();
}

bool PermissionManager::canDeleteUserAccounts() const
{
    return m_canDeleteUserAccounts;
}

void PermissionManager::setCanDeleteUserAccounts(bool newCanDeleteUserAccounts)
{
    if (m_canDeleteUserAccounts == newCanDeleteUserAccounts)
        return;
    m_canDeleteUserAccounts = newCanDeleteUserAccounts;
    emit canDeleteUserAccountsChanged();
}

bool PermissionManager::isAdmin() const
{
    return m_isAdmin;
}

void PermissionManager::setIsAdmin(bool newIsAdmin)
{
    if (m_isAdmin == newIsAdmin)
        return;
    m_isAdmin = newIsAdmin;
    emit isAdminChanged();
}
