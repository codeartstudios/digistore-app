import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../views"

StackLayout {
    id: root

    property alias dashboardLoader: dashboardloader
    property alias tellerLoader: tellerloader
    property alias inventoryLoader: inventoryloader
    property alias supplyLoader: supplyloader
    property alias salesLoader: salesloader
    property alias organizationLoader: organizationloader

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

    DsFlowLoader {
        id: supplyloader
        active: false
        asynchronous: true
        sourceComponent: Component {
            id: supplyComponent

            SupplyPage {
                id: supplyPage
            }
        }
    } // Supply Component

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

    Component {
        id: loadingIndicator

        BusyIndicator {
            width: 100
            height: 100
            running: true
        }
    }
}
