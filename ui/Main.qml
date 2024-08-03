import QtQuick

import "controls"
import "store"
import "flow"

Window {
    id: mainApp
    width: 640
    height: 480
    visibility: "Maximized"
    visible: true
    color: theme.bodyColor

    // Theme object
    property Theme theme: Theme{}

    // Store Object
    property Store store: Store{}

    // Icon Types
    property IconType dsIconType: IconType{}

    // Expose the tabler icons font loader
    property alias tablerIconsFontLoader: tablerIconsFontLoader

    // Application Flow
    property alias appFlow: appFlow

    FontLoader {
        id: tablerIconsFontLoader
        source: "qrc:/assets/fonts/tabler-icons.ttf"
    }

    DsRightDrawer {
        id: rightDrawer
    }

    ApplicationFlow {
        id: appFlow
    }

    // Component.onCompleted: rightDrawer.open()
}
