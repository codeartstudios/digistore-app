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

    Component.onCompleted: {
        // For quick tests ...
    }
}
