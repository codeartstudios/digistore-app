#ifndef PERMISSIONMANAGER_H
#define PERMISSIONMANAGER_H

#include <QObject>

#include "dscontroller.h"

class PermissionManager : public QObject
{
    Q_OBJECT
public:
    explicit PermissionManager(DsController *dsController, QObject *parent = nullptr);

    Q_PROPERTY(QVariantMap permissionTemplate READ permissionTemplate CONSTANT FINAL)

    // ------------------------------------------------------------------------------ //
    // Inventory permissions
    // ------------------------------------------------------------------------------ //
    Q_PROPERTY(bool canViewInventory READ canViewInventory WRITE setCanViewInventory NOTIFY canViewInventoryChanged FINAL)
    Q_PROPERTY(bool canCreateInventory READ canCreateInventory WRITE setCanCreateInventory NOTIFY canCreateInventoryChanged FINAL)
    Q_PROPERTY(bool canUpdateInventory READ canUpdateInventory WRITE setCanUpdateInventory NOTIFY canUpdateInventoryChanged FINAL)
    Q_PROPERTY(bool canDeleteInventory READ canDeleteInventory WRITE setCanDeleteInventory NOTIFY canDeleteInventoryChanged FINAL)

    // ------------------------------------------------------------------------------ //
    // Supply permissions
    // ------------------------------------------------------------------------------ //
    Q_PROPERTY(bool canViewSupply READ canViewSupply WRITE setCanViewSupply
                   NOTIFY canViewSupplyChanged FINAL)
    Q_PROPERTY(bool canCreateSupply READ canCreateSupply WRITE setCanCreateSupply NOTIFY canCreateSupplyChanged FINAL)
    Q_PROPERTY(bool canUpdateSupply READ canUpdateSupply WRITE setCanUpdateSupply NOTIFY canUpdateSupplyChanged FINAL)
    Q_PROPERTY(bool canDeleteSupply READ canDeleteSupply WRITE setCanDeleteSupply NOTIFY canDeleteSupplyChanged FINAL)

    // ------------------------------------------------------------------------------ //
    // Suppliers permissions
    // ------------------------------------------------------------------------------ //
    Q_PROPERTY(bool canViewSuppliers READ canViewSuppliers WRITE setCanViewSuppliers NOTIFY canViewSuppliersChanged FINAL)
    Q_PROPERTY(bool canCreateSuppliers READ canCreateSuppliers WRITE setCanCreateSuppliers NOTIFY canCreateSuppliersChanged FINAL)
    Q_PROPERTY(bool canUpdateSuppliers READ canUpdateSuppliers WRITE setCanUpdateSuppliers NOTIFY canUpdateSuppliersChanged FINAL)
    Q_PROPERTY(bool canDeleteSuppliers READ canDeleteSuppliers WRITE setCanDeleteSuppliers NOTIFY canDeleteSuppliersChanged FINAL)

    // ------------------------------------------------------------------------------ //
    // Sales properties
    // ------------------------------------------------------------------------------ //
    Q_PROPERTY(bool canViewSales READ canViewSales WRITE setCanViewSales NOTIFY canViewSalesChanged FINAL)
    Q_PROPERTY(bool canCreateSales READ canCreateSales WRITE setCanCreateSales NOTIFY canCreateSalesChanged FINAL)
    Q_PROPERTY(bool canUpdateSales READ canUpdateSales WRITE setCanUpdateSales NOTIFY canUpdateSalesChanged FINAL)
    Q_PROPERTY(bool canDeleteSales READ canDeleteSales WRITE setCanDeleteSales NOTIFY canDeleteSalesChanged FINAL)

    // ------------------------------------------------------------------------------ //
    // Organization properties
    // ------------------------------------------------------------------------------ //
    Q_PROPERTY(bool canViewOrganization READ canViewOrganization WRITE setCanViewOrganization NOTIFY canViewOrganizationChanged FINAL)
    Q_PROPERTY(bool canCreateOrganization READ canCreateOrganization WRITE setCanCreateOrganization NOTIFY canCreateOrganizationChanged FINAL)
    Q_PROPERTY(bool canUpdateOrganization READ canUpdateOrganization WRITE setCanUpdateOrganization NOTIFY canUpdateOrganizationChanged FINAL)
    Q_PROPERTY(bool canDeleteOrganization READ canDeleteOrganization WRITE setCanDeleteOrganization NOTIFY canDeleteOrganizationChanged FINAL)

    // ------------------------------------------------------------------------------ //
    // User accounts properties
    // ------------------------------------------------------------------------------ //
    Q_PROPERTY(bool canViewUserAccounts READ canViewUserAccounts WRITE setCanViewUserAccounts NOTIFY canViewUserAccountsChanged FINAL)
    Q_PROPERTY(bool canCreateUserAccounts READ canCreateUserAccounts WRITE setCanCreateUserAccounts NOTIFY canCreateUserAccountsChanged FINAL)
    Q_PROPERTY(bool canUpdateUserAccounts READ canUpdateUserAccounts WRITE setCanUpdateUserAccounts NOTIFY canUpdateUserAccountsChanged FINAL)
    Q_PROPERTY(bool canDeleteUserAccounts READ canDeleteUserAccounts WRITE setCanDeleteUserAccounts NOTIFY canDeleteUserAccountsChanged FINAL)

    // --------------------------------------------------------------------------- //
    // Invokables
    // ------------------------------------------------------------------------------ //

    // Syntax sugars for each table/module
    Q_INVOKABLE bool hasOrganizationPermission(const QString &action);
    Q_INVOKABLE bool hasUserAccountsPermission(const QString &action);
    Q_INVOKABLE bool hasSuppliersPermission(const QString &action);
    Q_INVOKABLE bool hasSupplyPermission(const QString &action);
    Q_INVOKABLE bool hasInventoryPermission(const QString &action);
    Q_INVOKABLE bool hasSalesPermission(const QString &action);

    // Read the permission template
    QVariantMap permissionTemplate() const;

    bool canViewInventory() const;
    void setCanViewInventory(bool newCanViewInventory);

    bool canCreateInventory() const;
    void setCanCreateInventory(bool newCanCreateInventory);

    bool canUpdateInventory() const;
    void setCanUpdateInventory(bool newCanUpdateInventory);

    bool canDeleteInventory() const;
    void setCanDeleteInventory(bool newCanDeleteInventory);

    bool canViewSupply() const;
    void setCanViewSupply(bool newCanViewSupply);

    bool canCreateSupply() const;
    void setCanCreateSupply(bool newCanCreateSupply);

    bool canUpdateSupply() const;
    void setCanUpdateSupply(bool newCanUpdateSupply);

    bool canDeleteSupply() const;
    void setCanDeleteSupply(bool newCanDeleteSupply);

    bool canViewSuppliers() const;
    void setCanViewSuppliers(bool newCanViewSuppliers);

    bool canCreateSuppliers() const;
    void setCanCreateSuppliers(bool newCanCreateSuppliers);

    bool canUpdateSuppliers() const;
    void setCanUpdateSuppliers(bool newCanUpdateSuppliers);

    bool canDeleteSuppliers() const;
    void setCanDeleteSuppliers(bool newCanDeleteSuppliers);

    bool canViewSales() const;
    void setCanViewSales(bool newCanViewSales);

    bool canCreateSales() const;
    void setCanCreateSales(bool newCanCreateSales);

    bool canUpdateSales() const;
    void setCanUpdateSales(bool newCanUpdateSales);

    bool canDeleteSales() const;
    void setCanDeleteSales(bool newCanDeleteSales);

    bool canViewOrganization() const;
    void setCanViewOrganization(bool newCanViewOrganization);

    bool canCreateOrganization() const;
    void setCanCreateOrganization(bool newCanCreateOrganization);

    bool canUpdateOrganization() const;
    void setCanUpdateOrganization(bool newCanUpdateOrganization);

    bool canDeleteOrganization() const;
    void setCanDeleteOrganization(bool newCanDeleteOrganization);

    bool canViewUserAccounts() const;
    void setCanViewUserAccounts(bool newCanViewUserAccounts);

    bool canCreateUserAccounts() const;
    void setCanCreateUserAccounts(bool newCanCreateUserAccounts);

    bool canUpdateUserAccounts() const;
    void setCanUpdateUserAccounts(bool newCanUpdateUserAccounts);

    bool canDeleteUserAccounts() const;
    void setCanDeleteUserAccounts(bool newCanDeleteUserAccounts);

signals:
    void canViewInventoryChanged();
    void canCreateInventoryChanged();
    void canUpdateInventoryChanged();
    void canDeleteInventoryChanged();

    void canViewSupplyChanged();
    void canCreateSupplyChanged();
    void canUpdateSupplyChanged();
    void canDeleteSupplyChanged();

    void canViewSuppliersChanged();
    void canCreateSuppliersChanged();
    void canUpdateSuppliersChanged();
    void canDeleteSuppliersChanged();

    void canViewSalesChanged();
    void canCreateSalesChanged();
    void canUpdateSalesChanged();
    void canDeleteSalesChanged();

    void canViewOrganizationChanged();
    void canCreateOrganizationChanged();
    void canUpdateOrganizationChanged();
    void canDeleteOrganizationChanged();

    void canViewUserAccountsChanged();
    void canCreateUserAccountsChanged();
    void canUpdateUserAccountsChanged();
    void canDeleteUserAccountsChanged();

private slots:
    void checkPermissions();

private:
    // ------------------------------------------------------------------------------ //
    // Private Class Functions
    // ------------------------------------------------------------------------------ //
    // Check for access permissions given;
    //  'module' -> Table name
    //  'action' -> read/write/delete/update/etc
    bool hasPermission(const QString &module, const QString &action);

    // ------------------------------------------------------------------------------ //
    // Class Member Variables
    // ------------------------------------------------------------------------------ //
    DsController *m_dsController;
    QVariantMap m_permissionTemplate;

    bool m_canViewInventory;
    bool m_canCreateInventory;
    bool m_canUpdateInventory;
    bool m_canDeleteInventory;

    bool m_canViewSupply;
    bool m_canCreateSupply;
    bool m_canUpdateSupply;
    bool m_canDeleteSupply;

    bool m_canViewSuppliers;
    bool m_canCreateSuppliers;
    bool m_canUpdateSuppliers;
    bool m_canDeleteSuppliers;

    bool m_canViewSales;
    bool m_canCreateSales;
    bool m_canUpdateSales;
    bool m_canDeleteSales;

    bool m_canViewOrganization;
    bool m_canCreateOrganization;
    bool m_canUpdateOrganization;
    bool m_canDeleteOrganization;

    bool m_canViewUserAccounts;
    bool m_canCreateUserAccounts;
    bool m_canUpdateUserAccounts;
    bool m_canDeleteUserAccounts;
};

#endif // PERMISSIONMANAGER_H
