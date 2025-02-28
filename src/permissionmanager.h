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

    // Check for access permissions given;
    //  'module' -> Table name
    //  'action' -> read/write/delete/update/etc
    Q_INVOKABLE bool hasPermission(const QString &module, const QString &action);

    // Syntax sugars for each table/module
    Q_INVOKABLE bool hasOrganizationPermission(const QString &action);
    Q_INVOKABLE bool hasUserAccountsPermission(const QString &action);
    Q_INVOKABLE bool hasSuppliersPermission(const QString &action);
    Q_INVOKABLE bool hasSupplyPermission(const QString &action);
    Q_INVOKABLE bool hasInventoryPermission(const QString &action);
    Q_INVOKABLE bool hasSalesPermission(const QString &action);

    // Getters
    QVariantMap permissionTemplate() const;

    // Permission checkers
    Q_INVOKABLE bool canViewInventory();
    Q_INVOKABLE bool canCreateInventory();
    Q_INVOKABLE bool canUpdateInventory();
    Q_INVOKABLE bool canDeleteInventory();

private:
    DsController *m_dsController;
    QVariantMap m_permissionTemplate;
};

#endif // PERMISSIONMANAGER_H
