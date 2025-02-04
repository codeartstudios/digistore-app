import QtQuick
import QtQuick.Controls
import app.digisto.modules

// TODO add notification dots

Item {
    id: sidebar
    width: Theme.appSidebarWidth

    property string currentSideBarMenu: "dashboard"
    property ListModel sideMenu: ListModel{}
    property ListModel sideMenuExtras: ListModel{}

    signal menuSelected(var label)

    Item {
        anchors.fill: parent
        anchors.margins: Theme.smSpacing

        Item {
            id: logoitem
            width: parent.width
            height: Theme.lgBtnHeight + Theme.smSpacing
            anchors.top: parent.top

            Item {
                width: parent.width
                height: Theme.lgBtnHeight

                Image {
                    width: Theme.btnHeight
                    height: Theme.btnHeight
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/assets/imgs/logo-nobg.png"
                    verticalAlignment: Image.AlignVCenter
                    anchors.centerIn: parent
                }
            }
        }

        DsSideBarListView {
            width: parent.width
            model: sideMenu
            anchors.bottom: extraslv.top
            anchors.top: logoitem.bottom
            anchors.bottomMargin: Theme.xsSpacing
        }

        DsSideBarListView {
            id: extraslv
            width: parent.width
            height: (sideMenuExtras.count * Theme.lgBtnHeight) + ((sideMenuExtras.count-1) * spacing)
            anchors.bottom: parent.bottom
            model: sideMenuExtras
        }

    }

    // Right Border line for the sidebar
    Rectangle {
        width: 1
        height: parent.height
        color: Theme.baseAlt1Color
        anchors.right: parent.right
    } // Rectangle: Right border line

    Component.onCompleted: {
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
                            tooltip: "Cart Checkout",
                            isBusy: false,
                            iconType: IconType.shoppingCartCheck
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
                            label: "organization",
                            tooltip: "My Organization",
                            isBusy: false,
                            iconType: IconType.briefcase2
                        })

        sideMenu.append({
                            checkable: true,
                            label: "sales",
                            tooltip: "Org. Sales",
                            isBusy: false,
                            iconType: IconType.tableShare
                        })
        sideMenu.append({
                            checkable: false,
                            label: "pocketbaseadmin",
                            tooltip: "Pocketbase Admin",
                            isBusy: false,
                            iconType: IconType.databaseCog
                        })
        sideMenu.append({
                            checkable: true,
                            label: "accounts",
                            tooltip: "Accounts & Permissions",
                            isBusy: false,
                            iconType: IconType.users
                        })

        sideMenuExtras.append({
                                  checkable: true,
                                  label: "notifications",
                                  tooltip: "Notifications",
                                  isBusy: false,
                                  iconType: IconType.bell
                              })

        sideMenuExtras.append({
                                  checkable: true,
                                  label: "settings",
                                  tooltip: "App Settings",
                                  isBusy: false,
                                  iconType: IconType.settings
                              })

        sideMenuExtras.append({
                                  checkable: true,
                                  label: "profile",
                                  tooltip: "User Profile",
                                  isBusy: false,
                                  iconType: IconType.userScreen
                              })
    }
}
