import QtQuick
import QtQuick.Layouts
import app.digisto.modules

import "controls" // Settings
import "../../controls"

DsSettingsStackPage {
    id: root
    title: qsTr("General")

    property string appVersion: "0.0.1"
    property var appReleaseDate: new Date()

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

    DsSettingsCard {
        title: qsTr("App Updates")
        desc: qsTr("Keeping up with the latest version released.")

        RowLayout {
            width: parent.width

            DsLabel {
                text: qsTr("Always check for updates on boot")
                fontSize: Theme.baseFontSize
                color: Theme.txtPrimaryColor
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }

            DsSwitch {
                checked: true
                bgColor: Theme.bodyColor
                Layout.alignment: Qt.AlignVCenter
            }
        }

        RowLayout {
            width: parent.width

            Column {
                spacing: Theme.btnRadius
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                DsLabel {
                    text: qsTr("App Version") + `: ${root.appVersion}`
                    fontSize: Theme.baseFontSize
                    color: Theme.txtPrimaryColor
                }

                DsLabel {
                    text: qsTr("Released") + `: ${root.appReleaseDate}`
                    fontSize: Theme.xsFontSize
                    color: Theme.txtHintColor
                }
            }

            DsButton {
                text: qsTr("Check for Updates")
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }
}
