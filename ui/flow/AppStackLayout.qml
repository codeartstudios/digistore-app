import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../views"

StackLayout {
    id: root

    property alias dashboardLoader: dashboardloader
    property alias tellerLoader: tellerloader
    property alias inventoryLoader: inventoryloader
    property alias salesLoader: salesloader
    property alias organizationLoader: organizationloader
    property alias settingsLoader: settingsloader
    property alias notificationLoader: notificationloader
    property alias accountsLoader: accountsloader

    // DashboardPage
    DsFlowLoader {
        id: dashboardloader
        active: false
        asynchronous: true
        sourceComponent: Component {
            id: dashboardComponent

            DashboardPage {
                id: dashboardPage
            }
        }
    } // DashboardPage Loader

    // TellerPage Loader
    DsFlowLoader {
        id: tellerloader
        active: false // root.currentIndex===1
        asynchronous: true
        sourceComponent: Component {
            id: tellerComponent

            TellerPage {
                id: tellerPage
            }
        }
    } // Teller Component [Checkout]

    // InventoryPage Loader
    DsFlowLoader {
        id: inventoryloader
        active: false // root.currentIndex===2
        asynchronous: true
        sourceComponent: Component {
            id: inventoryComponent

            InventoryPage {
                id: inventoryPage
            }
        }
    } // Inventory Component

    // OrganizationPage Loader
    DsFlowLoader {
        id: organizationloader
        active: false // root.currentIndex===3
        asynchronous: true
        sourceComponent: Component {
            id: organizationComponent

            OrganizationPage {
                id: organizationPage
            }
        }
    } // Organization Component

    // SalesPage Loader
    DsFlowLoader {
        id: salesloader
        active: false // root.currentIndex===4
        asynchronous: true
        sourceComponent: Component {
            id: salesComponent

            SalesPage {
                id: salesPage
            }
        }
    } // Sales Component

    // SettingsPage Loader
    DsFlowLoader {
        id: settingsloader
        active: false // root.currentIndex===5
        asynchronous: true
        sourceComponent: Component {
            id: settingsComponent

            SettingsPage {
                id: settingsPage
            }
        }
    } // Settings Component

    // NotificationPage Loader
    DsFlowLoader {
        id: notificationloader
        active: false // root.currentIndex===6
        asynchronous: true
        sourceComponent: Component {
            id: notificationComponent

            NotificationPage {
                id: notificationPage
            }
        }
    } // Notification Component

    // AccountsPage Loader
    DsFlowLoader {
        id: accountsloader
        active: false // root.currentIndex===7
        asynchronous: true
        sourceComponent: Component {
            id: accountsComponent

            AccountsPage {
                id: accountsPage
            }
        }
    } // Accounts Component

    Component {
        id: loadingIndicator

        BusyIndicator {
            width: 100
            height: 100
            running: true
        }
    }
}
