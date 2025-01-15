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
    property alias appFlow: appFlow

    FontLoader {
        id: tablerIconsFontLoader
        source: "qrc:/assets/fonts/tabler-icons.ttf"
    }

    ApplicationFlow {
        id: appFlow
    }

    Connections {
        target: dsController

        function onStartWindowMaximizedChanged() {
            if(dsController.startWindowMaximized) {
                mainApp.showMaximized();
            } else {
                mainApp.showNormal();
            }
        }
    }
}
