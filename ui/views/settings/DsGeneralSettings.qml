import QtQuick
import QtQuick.Layouts
import app.digisto.modules

import "controls" // Settings
import "../../controls"

DsSettingsStackPage {
    id: root
    title: qsTr("General")

    DsSettingsCard {
        title: qsTr("Theme")
        desc: qsTr("Tweak the app look and feel.")

        RowLayout {
            width: parent.width

            DsLabel {
                text: qsTr("Application theme")
                fontSize: Theme.baseFontSize
                color: Theme.txtPrimaryColor
                Layout.fillWidth: true
            }

            DsComboBox {
                Layout.minimumWidth: 300
                currentIndex: 0
                radius: Theme.btnRadius
                model: [qsTr("Light Theme"), qsTr("Dark Theme"), qsTr("Same as system")]
            }
        }
    }
}
