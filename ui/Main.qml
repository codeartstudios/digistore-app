import QtQuick
import app.digisto.modules

import "controls"
import "flow"
import "popups"

import "js/main.js" as Djs

Window {
    id: mainApp
    width: 1080
    height: 720
    visible: true
    color: Theme.bodyColor

    // Hold Current Date/Time
    property var currentDateTime: new Date()

    // Expose the tabler icons font loader
    property alias tablerIconsFontLoader: tablerIconsFontLoader

    // Application Flow
    // property alias appFlow: appFlow
    property alias toast: toast

    // Create UserPermission object: Manage all user permissions centrally
    property UserPermissions loggedUserPermissions: UserPermissions{}

    // Add Global Models to the mainApp
    property GlobalModels globalModels: GlobalModels{}

    FontLoader {
        id: tablerIconsFontLoader
        source: "qrc:/assets/fonts/tabler-icons.ttf"
    }

    ApplicationFlow { id: appFlow }

    DsToast { id: toast }

    property var orgCurrency: ({})

    function withOpacity(color, opacity) {
        return Utils.withOpacity(color, opacity)
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: currentDateTime = new Date()
    }

    function hasOrgPermissions(access) {
        return dsPermissionManager.hasPermission("organization", "write")
    }

    Component.onCompleted: {
        // For quick tests ...
        console.log("organization [write] ? ", dsPermissionManager.hasPermission("organization", "write"))
        console.log("organization [view] ? ", dsPermissionManager.hasPermission("organization", "view"))
        console.log("organization [update] ? ", dsPermissionManager.hasPermission("organization", "update"))
        console.log("inventory [create] ? ", dsPermissionManager.hasPermission("inventory", "create"))
        console.log("inventory [view] ? ", dsPermissionManager.hasPermission("inventory", "view"))
        console.log("inventory [update] ? ", dsPermissionManager.hasPermission("inventory", "update"))
        // var j = {
        //     data: {
        //         data: {},
        //         message: "Failed to authenticate.",
        //         status: 400
        //     },
        //     error:"Error transferring http://127.0.0.1:3000/api/collections/tellers/auth-with-password?expand=organization - server replied: Bad Request",
        //     status:400
        // }

        // console.log(Utils.error(j))
    }

    // Convert response object to error string
    function toErrorString(resObj) {
        return Utils.error(resObj)
    }

    // Lets monitor the token changes,
    // TODO remove this before production
    Connections {
        target: dsController

        // Signal handler for window size state change saved in the
        // application settings.
        function onStartWindowMaximizedChanged() {
            if(dsController.startWindowMaximized) {
                mainApp.showMaximized();    // Maximize the window
            } else {
                mainApp.showNormal();       // Show the default size window (1080x720px)
            }
        }

        function onOrganizationChanged() {
            if(!dsController.organization) {
                orgCurrency = {}
                return
            }

            var settings = dsController.organization.settings
            const currency = settings && settings.currency ? settings.currency : 'usd'
            const currencyObj = StaticModels.findCurrencyFromModel(
                                  currency, 'cc', (m, v) => {
                                      return m.toLowerCase()===v.toLowerCase()
                                  })
            orgCurrency = currencyObj
        }
    }
}
