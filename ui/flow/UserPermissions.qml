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

    // Check if logged in user can manage organization parameters
    property bool canEditOrganization: (isAdmin || (dsController.loggedUser!==null &&
                                                    dsController.loggedUser.permissions &&
                                                    dsController.loggedUser.permissions.can_manage_org===true)) ? true : false
    // role [ admin, teller, ]
    // supplier [view, add, manage] (stock)
    // product [view, add, manage, sell]
    // organization [
    //   "can_add_products": false,
    //   "can_add_stock": false,
    //   "can_add_suppliers": false,
    //   "can_manage_inventory": false,
    //   "can_manage_org": false,
    //   "can_manage_products": false,
    //   "can_manage_sales": false,
    //   "can_manage_stock": false,
    //   "can_manage_suppliers": false,
    //   "can_manage_users": false,
    //   "can_sell_products": false
    //--------------------- INVENTORY ROLES -------------------------//
    property bool canAddStock: (isAdmin || (dsController.loggedUser!==null &&
                                            dsController.loggedUser.permissions &&
                                            dsController.loggedUser.permissions.can_manage_org===true)) ? true : false

    property bool canAddStock: (isAdmin || (dsController.loggedUser!==null &&
                                            dsController.loggedUser.permissions &&
                                            dsController.loggedUser.permissions.can_manage_org===true)) ? true : false
}
