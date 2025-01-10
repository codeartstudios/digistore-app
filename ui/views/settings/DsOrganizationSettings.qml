import QtQuick
import QtQuick.Layouts
import app.digisto.modules

import "controls" // Settings
import "../../controls"

DsSettingsStackPage {
    id: root
    title: qsTr("Organization")

    DsSettingsCard {
        title: qsTr("Organization")
        desc: qsTr("General app settings")
    }
}
