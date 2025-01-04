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

    ColumnLayout {
        id: collayout
        spacing: 0
        anchors.fill: parent

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

        AppStackLayout {
            id: appStackLayout

            Component.onCompleted: appStackLayout.dashboardLoader.active=true;

            Connections {
                target: sideBar

                function onMenuSelected(label) {
                    switch(label) {
                    case "dashboard": {
                        appStackLayout.currentIndex=0;
                        appStackLayout.dashboardLoader.active=true;
                        break;
                    }

                    case "teller": {
                        appStackLayout.currentIndex=1;
                        appStackLayout.tellerLoader.active=true;
                        break;
                    }

                    case "inventory": {
                        appStackLayout.currentIndex=2;
                        appStackLayout.inventoryLoader.active=true;
                        break;
                    }

                    case "suppliers": {
                        appStackLayout.currentIndex=3;
                        appStackLayout.suppliersLoader.active=true;
                        break;
                    }

                    case "supply": {
                        appStackLayout.currentIndex=4;
                        appStackLayout.supplyLoader.active=true;
                        break;
                    }

                    case "organization": {
                        appStackLayout.currentIndex=5;
                        appStackLayout.organizationLoader.active=true;
                        break;
                    }

                    case "sales": {
                        appStackLayout.currentIndex=6;
                        appStackLayout.salesLoader.active=true;
                        break;
                    }

                    case "notifications": {
                        // postAuthLoader.sourceComponent = salesStackComponent;
                        break;
                    }

                    case "settings": {
                        // postAuthLoader.sourceComponent = salesStackComponent;
                        break;
                    }

                    case "profile": {
                        // postAuthLoader.sourceComponent = salesStackComponent;
                        break;
                    }

                    case "pocketbaseadmin": {
                        pocketbaseAdminPage.show()
                        break;
                    }
                    }
                }
            }
        }
    }

    PocketbaseAdminPage {
        id: pocketbaseAdminPage
    }

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
