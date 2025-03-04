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
    property UserPermissions dsPermissions: UserPermissions{}

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

    // Show the toast widget
    function showPermissionDeniedWarning(toastWidget=null) {
        if(toastWidget) toastWidget.warning(qsTr("Access denied!"))
        else toast.warning(qsTr("Access denied!"))
    }

    // Convert response object to error string
    function toErrorString(resObj) {
        return Utils.error(resObj)
    }

    // ------------------------------------------------------------------------------ //
    // Connection for dsController signals
    // ------------------------------------------------------------------------------ //

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

    // ------------------------------------------------------------------------------ //
    // onCompleted signal handler
    // ------------------------------------------------------------------------------ //

    Component.onCompleted: {
        // For quick tests ...
    }
}
