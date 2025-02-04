import QtQuick

QtObject {
    // Is an admin account
    property bool isAdmin: dsController.loggedUser &&
                           dsController.loggedUser.is_admin

    // User has the  permission to sell products (teller mode)
    property bool canSellProducts: dsController.loggedUser &&
                                   dsController.loggedUser.permissions &&
                                   dsController.loggedUser.permissions.can_sell_products
}
