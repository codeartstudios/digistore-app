import QtQuick
import app.digisto.modules

import "controls"
import "store"
import "flow"

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

        const now = new Date();
        const dayOfWeek = now.getDay(); // 0 (Sunday) to 6 (Saturday)

        // Calculate start and end dates
        const startDate = new Date(now);
        startDate.setDate(now.getDate() - dayOfWeek); // Go back to Sunday

        const endDate = new Date(startDate);
        endDate.setDate(startDate.getDate() + 6); // Add 6 days to get Saturday

        console.log(startDate, endDate)
    }
}
