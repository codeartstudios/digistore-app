import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

// User imports
import "../controls"
import "../views"
import "../popups"
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

            Onboarding {
                id: onboardingPage
            }
        }
    }

    DsUserProfileContextPopup {
        id: profilePopup
    }

    Component {
        id: postAuthComponent

        AppStackLayout {
            id: appStackLayout

            Component.onCompleted: appStackLayout.dashboardLoader.active=true; // overrideActiveTab() //

            function overrideActiveTab() {
                sideBar.currentSideBarMenu = "inventory"
                appStackLayout.currentIndex=2;
                appStackLayout.inventoryLoader.active=true;
            }

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

                    case "organization": {
                        appStackLayout.currentIndex=3;
                        appStackLayout.organizationLoader.active=true;
                        break;
                    }

                    case "sales": {
                        appStackLayout.currentIndex=4;
                        appStackLayout.salesLoader.active=true;
                        break;
                    }

                    case "settings": {
                        appStackLayout.currentIndex=5;
                        appStackLayout.settingsLoader.active=true;
                        break;
                    }

                    case "notifications": {
                        appStackLayout.currentIndex=6;
                        appStackLayout.notificationLoader.active=true;
                        break;
                    }

                    case "accounts": {
                        appStackLayout.currentIndex=7;
                        appStackLayout.accountsLoader.active=true;
                        break;
                    }

                    case "profile": {
                        profilePopup.open()
                        break;
                    }

                    case "pocketbaseadmin": {
                        Qt.openUrlExternally('http://127.0.0.1:8090/_/')
                        // pocketbaseAdminPage.show()
                        break;
                    }
                    }
                }
            }
        }
    }
}
