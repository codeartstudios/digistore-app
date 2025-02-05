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
        width: root.width
        title: qsTr("Theme")
        desc: qsTr("Tweak the app look and feel.")

        RowLayout {
            width: parent.width

            DsLabel {
                text: qsTr("Enable Dark Theme")
                fontSize: Theme.baseFontSize
                color: Theme.txtPrimaryColor
                Layout.fillWidth: true
            }

            DsSwitch {
                bgColor: Theme.bodyColor
                checked: dsController.isDarkTheme
                Layout.alignment: Qt.AlignVCenter

                onCheckedChanged: {
                    dsController.isDarkTheme = checked
                    dsController.setValue("isDarkTheme", "bool", checked)
                }
            }
        }

        RowLayout {
            width: parent.width

            DsLabel {
                text: qsTr("Start the window maximized")
                fontSize: Theme.baseFontSize
                color: Theme.txtPrimaryColor
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }

            DsSwitch {
                bgColor: Theme.bodyColor
                checked: dsController.startWindowMaximized
                Layout.alignment: Qt.AlignVCenter

                onCheckedChanged: {
                    dsController.startWindowMaximized = checked
                    dsController.setValue("startWindowMaximized", "bool", checked)
                }
            }
        }

        /// Language ... // TODO
    }

    DsSettingsCard {
        width: root.width
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
