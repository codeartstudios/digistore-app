import QtQuick
import app.digisto.modules

import "controls"
import "store"
import "flow"
import "popups"

Window {
    id: mainApp
    width: 640
    height: 480
    visibility: "Maximized"
    visible: true
    color: Theme.bodyColor

    // Store Object
    property Store store: Store{}

    // Expose the tabler icons font loader
    property alias tablerIconsFontLoader: tablerIconsFontLoader

    // Application Flow
    property alias appFlow: appFlow

    FontLoader {
        id: tablerIconsFontLoader
        source: "qrc:/assets/fonts/tabler-icons.ttf"
    }

    ApplicationFlow {
        id: appFlow
    }

    Component.onCompleted: {
        // TODO set these from API response
        dsController.organizationID = "main";
    }
}
