import QtQuick
import app.digisto.modules

Item {
    // Organization Page Tab Model
    // Holds the tab information for tab switching
    property ListModel orgTabModel: ListModel{}


    property string currentSideBarMenu: "dashboard"
    property ListModel sideMenu: ListModel{}
    property ListModel sideMenuExtras: ListModel{}

    function populateOrgTabModel() {
        orgTabModel.clear()
        orgTabModel.append({
                               label: "Info",
                               iconType: IconType.infoCircle
                               // componentId: orginfoloader
                           })

        orgTabModel.append({
                               label: "Accounts & Permissions",
                               iconType: IconType.users
                               // componentId: orginfoloader
                           })

        orgTabModel.append({
                               label: "Branches",
                               iconType: IconType.gitMerge
                               // componentId: orgbranchesloader
                           })

        orgTabModel.append({
                               label: "Settings",
                               iconType: IconType.settings
                               // componentId: orgsettingsloader
                           })
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
                                  checkable: true,
                                  label: "profile",
                                  tooltip: "User Profile",
                                  isBusy: false,
                                  iconType: IconType.userScreen
                              })
    }

    Component.onCompleted: {
        populateOrgTabModel()
        populateSideMenuModel()
    }
}
