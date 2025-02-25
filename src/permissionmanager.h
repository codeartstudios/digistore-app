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

    Q_INVOKABLE bool hasPermission(const QString &module, const QString &action);
    QVariantMap permissionTemplate() const;

signals:

private:
    DsController *m_dsController;
    QVariantMap m_permissionTemplate;
};

#endif // PERMISSIONMANAGER_H
