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
    }

    function withOpacity(color, opacity) {
        return Utils.withOpacity(color, opacity)
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: currentDateTime = new Date()
    }

    Component.onCompleted: {
        // For quick tests ...
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

    // Lets monitor the token changes,
    // TODO remove this before production
    Connections {
        target: dsController

        function onTokenChanged() {
            console.log("Token changed to: '", dsController.token, "'")
        }
    }
}
