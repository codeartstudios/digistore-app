#ifndef PERMISSIONMANAGER_H
#define PERMISSIONMANAGER_H

#include <QObject>

#include "dscontroller.h"

class PermissionManager : public QObject
{
    Q_OBJECT
public:
    explicit PermissionManager(DsController *dsController, QObject *parent = nullptr);

signals:

private:
    DsController *m_dsController;
};

#endif // PERMISSIONMANAGER_H
