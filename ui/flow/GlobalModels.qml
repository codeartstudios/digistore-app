import QtQuick
import app.digisto.modules

Item {
    // Organization Page Tab Model
    // Holds the tab information for tab switching
    property ListModel orgTabModel: ListModel{}

    // Template for user permissions, readonly mode
    readonly property var userPermissonsTemplate: {
        'can_add_stock': false,
        'can_manage_stock': false,
        'can_sell_products': false,
        'can_add_products': false,
        'can_manage_products': false,
        'can_add_suppliers': false,
        'can_manage_suppliers': false,
        'can_manage_sales': false,
        'can_manage_inventory': false,
        'can_manage_org': false,
        'can_manage_users': false
    }

    readonly property var orgSettingsTemplate: {
        'currency': 'usd',
        'screen_timeout_enabled': true,
        'users_can_delete_own_accounts': false
    }

    // Email Regex Validator
    readonly property RegularExpressionValidator emailRegex: RegularExpressionValidator { // Email Regex
        regularExpression: /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/
    }

    property string currentSideBarMenu: "dashboard"
    property ListModel sideMenu: ListModel{}
    property ListModel sideMenuExtras: ListModel{}

    // Model to hold the top pill data
    property ListModel gridModel: ListModel {
        ListElement {
            period: '7days'
            label: qsTr("Total Sales")
            description: ''
            refValue: 0
            value: 0
            deviationShown: true
            trendIconShown: true
            periodSelectorShown: true
            calculateFunc: (n,o) => calculateFunc1(n,o)
        }

        ListElement {
            period: '7days'
            label: qsTr("No. of Sales")
            description: qsTr("Sales transactions completed")
            refValue: 0
            value: 0
            deviationShown: true
            trendIconShown: true
            periodSelectorShown: true
            calculateFunc: (n,o) => calculateFunc1(n,o)
        }

        ListElement {
            period: '7days'
            label: qsTr("Stock Status")
            description: qsTr("Current stock available for sale")
            refValue: 0
            value: 0
            deviationShown: true
            trendIconShown: false
            periodSelectorShown: false
            calculateFunc: (n,o) => calculateFunc2(n,o)
        }

        ListElement {
            period: '7days'
            label: qsTr("Low Stock Products")
            description: qsTr("Number of products with critically low stock")
            value: 0
            refValue: 0
            deviationShown: false
            trendIconShown: false
            periodSelectorShown: false
            calculateFunc: (n,o) => calculateFunc1(n,o)
        }
    }

    function calculateFunc1(_new, _old) {
        if(_old===null) return 0

        // Catch when _old is zero
        if(_old === _new && _old === 0) return 0

        // Calculate deviation
        var devt = 0
        if(_old===0)
            devt = _new * 100   // We can't divide by 0
        else
            devt = (_new - _old)/_old * 100

        // Return deviation percentage
        return devt%1 === 0 ? devt : devt.toFixed(1)
    }

    function calculateFunc2(val, tot) {
        if(tot === 0) return val*100
        else return ((val/tot) * 100).toFixed(1)
    }

    function populateSideMenuModel() {
        sideMenu.clear()
        sideMenuExtras.clear()

        sideMenu.append({
                            checkable: true,
                            label: "dashboard",
                            tooltip: "Org. Dashboard",
                            isBusy: false,
                            iconType: IconType.chalkboard
                        })

        sideMenu.append({
                            checkable: true,
                            label: "teller",
                            tooltip: "Teller Page",
                            isBusy: false,
                            iconType: IconType.shoppingCartBolt
                        })

        sideMenu.append({
                            checkable: true,
                            label: "inventory",
                            tooltip: "Org. Inventory",
                            isBusy: false,
                            iconType: IconType.database
                        })

        sideMenu.append({
                            checkable: true,
                            label: "sales",
                            tooltip: "Sales & Reports",
                            isBusy: false,
                            iconType: IconType.chartBarPopular
                        })

        sideMenu.append({
                            checkable: true,
                            label: "organization",
                            tooltip: "My Organization",
                            isBusy: false,
                            iconType: IconType.sitemap
                        })

        // sideMenuExtras.append({
        //                           checkable: true,
        //                           label: "notifications",
        //                           tooltip: "Notifications",
        //                           isBusy: false,
        //                           iconType: IconType.bell
        //                       })

        sideMenuExtras.append({
                                  checkable: true,
                                  label: "settings",
                                  tooltip: "App Settings",
                                  isBusy: false,
                                  iconType: IconType.settings
                              })

        sideMenuExtras.append({
                                  checkable: false,
                                  label: "profile",
                                  tooltip: "User Profile",
                                  isBusy: false,
                                  iconType: IconType.userScreen
                              })
    }

    Component.onCompleted: {
        populateSideMenuModel()
        gridModel.setProperty(0, 'description', qsTr("Revenue generated in") + ` ${dsController.organization.settings.currency.toUpperCase()}`)
    }
}
