import QtQuick

QtObject {
    // Is an admin account
    property bool isAdmin: dsController.loggedUser!==null &&
                           dsController.loggedUser.is_admin ? true : false

    // User has the  permission to sell products (teller mode)
    property bool canSellProducts: dsController.loggedUser!==null &&
                                   dsController.loggedUser.permissions &&
                                   dsController.loggedUser.permissions.can_sell_products ? true : false

    property bool canEditPermissions: (isAdmin || (dsController.loggedUser!==null &&
                                                   dsController.loggedUser.permissions &&
                                                   dsController.loggedUser.permissions.can_manage_users===true)) ? true : false

    property bool canAddUsers: (isAdmin || (dsController.loggedUser!==null &&
                                            dsController.loggedUser.permissions &&
                                            dsController.loggedUser.permissions.can_manage_users===true)) ? true : false
}
