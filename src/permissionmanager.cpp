#include "permissionmanager.h"

PermissionManager::PermissionManager(DsController *dsController, QObject *parent)
    : QObject{parent},
    m_dsController(dsController)
{}
