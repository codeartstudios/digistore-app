import QtQuick
import app.digisto.modules

import "controls"
import "store"
import "flow"
import "popups"

Window {
    id: mainApp
    width: 1080
    height: 720
    visible: true
    color: Theme.bodyColor

    // Store Object
    property Store store: Store{}

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

    // Logic to check if the user is actually logged in or not
    // Checks for token validity, organization validity and
    // logged in user validity.
    function checkIfLoggedIn() {
        // Check if JWT is valid
        var tokenIsValid = dsController.validateToken();

        // Check if logged in user is structurally valid
        var loggedUserIsValid = dsController.loggedUser &&
                dsController.loggedUser.id && dsController.loggedUser.id!=="" &&
                dsController.loggedUser.name && dsController.loggedUser.name!==""

        // Check if organization structure is valid
        var orgIsValid = dsController.organization &&
                dsController.organization.name && dsController.organization.name!=="" &&
                dsController.organization.id && dsController.organization.id!==""

        // console.log(tokenIsValid, loggedUserIsValid, orgIsValid)
        return tokenIsValid===true && loggedUserIsValid===true && orgIsValid===true
    }

    function logout() {
        // Clear token
        dsController.token = ''
        store.userLoggedIn = checkIfLoggedIn()
        toast.info(qsTr("Logout Success!"))
    }

    // Fetch total sales
    Requests {
        id: r
        token: dsController.token
        baseUrl: dsController.baseUrl
        path: "/fn/dashboard/total-sales"
    }

    function _get_() {
        const today = new Date();
        const startDate = today;
        startDate.setMonth(today.getMonth() - 2); // Start from 3 months ago

        const oldDate = startDate;
        oldDate.setMonth(startDate.getMonth() - 3); // Start from 6 months ago

        var t1 = Qt.formatDateTime(startDate, "yyyy-MM-dd 00:00:00.000Z")
        var t2 = Qt.formatDateTime(oldDate, "yyyy-MM-dd 00:00:00.000Z")

        var query = {
            filter: `organization = '${dsController.workspaceId}'` +
                    ` && startDate = '${t1}' && oldDate = '${t2}'`
        }

        r.clear()
        r.query = query;
        var res = r.send();

        console.log('-> ', res, JSON.stringify(res))

        if(res.status===200) {
            var data = res.data;

        }

        else {
            // showMessage(
            //             qsTr("Error fetching products"),
            //             qsTr("There was an issue when fetching products: ") + `[${res.status}]${res.data.message}`
            //             )
        }
    }
}
