import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

// User imports
import "../controls"
import "../views"
import "../views/auth"

Item {
    anchors.fill: parent

    property bool sidebarShown: true
    property alias topBar: topbar

    ColumnLayout {
        id: collayout
        spacing: 0
        anchors.fill: parent

        DsTopNavigationBar {
            id: topbar
            visible: store.userLoggedIn
            Layout.preferredHeight: store.userLoggedIn ? implicitHeight : 0
            Layout.fillWidth: true
        }

        RowLayout {
            spacing: 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            DsSideBar {
                id: sideBar
                visible: store.userLoggedIn
                Layout.preferredWidth: store.userLoggedIn && sidebarShown ? Theme.appSidebarWidth : 0
                Layout.fillHeight: true
            }

            Loader {
                id: applicationLoader
                active: true
                sourceComponent: store.userLoggedIn ? postAuthComponent : preAuthComponent
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    Component {
        id: preAuthComponent

        DsNavigationStack {
            id: preAuthStack

            Login {
                id: loginPage
            }
        }
    }

    Component {
        id: postAuthComponent

        StackView {
            id: mainStack
            initialItem: StackLayout {
                anchors.fill: parent

                Connections {
                    target: sideBar

                    function onMenuSelected(label) {
                        switch(label) {
                        case "dashboard": {
                            postAuthLoader.sourceComponent = dashboardStackComponent;
                            break;
                        }

                        case "teller": {
                            postAuthLoader.sourceComponent = tellerStackComponent;
                            break;
                        }

                        case "inventory": {
                            postAuthLoader.sourceComponent = inventoryStackComponent;
                            break;
                        }

                        case "organization": {
                            postAuthLoader.sourceComponent = organizationStackComponent;
                            break;
                        }

                        case "sales": {
                            postAuthLoader.sourceComponent = salesStackComponent;
                            break;
                        }
                        }
                    }
                }

                Loader {
                    id: postAuthLoader
                    active: true
                    sourceComponent: dashboardStackComponent
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }

    Component {
        id: dashboardStackComponent

        DsNavigationStack {
            id: dashboardStack

            DashboardPage {
                id: dashboardPage
            }
        }
    }

    Component {
        id: tellerStackComponent

        DsNavigationStack {
            id: tellerStack

            TellerPage {
                id: tellerPage
            }
        }
    } // Teller Component [Checkout]

    Component {
        id: inventoryStackComponent

        DsNavigationStack {
            id: inventoryStack

            InventoryPage {
                id: inventoryPage
            }
        }
    } // Inventory Component

    Component {
        id: organizationStackComponent

        DsNavigationStack {
            id: organizationStack

            OrganizationPage {
                id: organizationPage
            }
        }
    } // Organization Component

    Component {
        id: salesStackComponent

        DsNavigationStack {
            id: salesStack

            SalesPage {
                id: salesPage
            }
        }
    } // Sales Component

    function withOpacity(color, opacity) {
        var r, g, b;

        // Named color
        if (color.startsWith("#")) {
            if (color.length === 7) { // #RRGGBB
                r = parseInt(color.substr(1, 2), 16) / 255.0;
                g = parseInt(color.substr(3, 2), 16) / 255.0;
                b = parseInt(color.substr(5, 2), 16) / 255.0;
            } else if (color.length === 4) { // #RGB
                r = parseInt(color.substr(1, 1) + color.substr(1, 1), 16) / 255.0;
                g = parseInt(color.substr(2, 1) + color.substr(2, 1), 16) / 255.0;
                b = parseInt(color.substr(3, 1) + color.substr(3, 1), 16) / 255.0;
            }
        } else if (color.startsWith("rgb")) {
            var rgbValues = color.match(/\d+/g);
            r = rgbValues[0] / 255.0;
            g = rgbValues[1] / 255.0;
            b = rgbValues[2] / 255.0;
        } else {
            // If it's a named color
            var tmpColor = Qt.color(color);
            r = tmpColor.r;
            g = tmpColor.g;
            b = tmpColor.b;
        }

        return Qt.rgba(r, g, b, opacity);
    }
}
