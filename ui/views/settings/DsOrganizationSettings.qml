import QtQuick
import QtQuick.Layouts
import app.digisto.modules

import "controls" // Settings
import "../../controls"

DsSettingsStackPage {
    id: root
    title: qsTr("Organization")

    // Organization Details
    DsSettingsCard {
        title: qsTr("Organization")
        desc: qsTr("General app settings")
    }

    // Organization Settings
    DsSettingsCard {
        title: qsTr("Organization Settings")
        desc: qsTr("Configure organization settings")

        // Workspace
        RowLayout {
            width: parent.width
            spacing: Theme.xsSpacing

            DsLabel {
                text: qsTr("Workspace URL")
                fontSize: Theme.baseFontSize
                color: Theme.txtPrimaryColor
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            DsInputWithLabel {
                id: orgworkspaceinput
                labelShown: false
                color: Theme.bodyColor
                input.placeholderText: qsTr("xxxx.digisto.app")
                Layout.minimumWidth: 300
            }
        }

        // Domain
        RowLayout {
            width: parent.width
            spacing: Theme.xsSpacing

            DsLabel {
                text: qsTr("Server Root Domain")
                fontSize: Theme.baseFontSize
                color: Theme.txtPrimaryColor
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            DsInputWithLabel {
                id: domaininput
                labelShown: false
                color: Theme.bodyColor
                input.placeholderText: qsTr("https://digisto.app")
                Layout.minimumWidth: 300
            }
        }

        // Lock timeout
        RowLayout {
            width: parent.width
            spacing: Theme.xsSpacing

            DsLabel {
                text: qsTr("App lock timeout")
                fontSize: Theme.baseFontSize
                color: Theme.txtPrimaryColor
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            DsComboBox {
                id: screenlockcb
                height: Theme.inputHeight + Theme.xsSpacing
                radius: Theme.btnRadius
                bgColor: Theme.bodyColor
                model: [qsTr("1 Minute"), qsTr("5 Minutes"), qsTr("15 Minutes"), qsTr("30 Minutes"), qsTr("1 Hour")]
                Layout.minimumWidth: 300
            }
        }

    }

    DsLabel {
        text: qsTr("Product Settings")
        fontSize: Theme.baseFontSize
        color: Theme.txtPrimaryColor
    }

    // Organization Settings
    DsSettingsCard {
        title: qsTr("Organization Settings")
        desc: qsTr("Configure organization settings")

        // Update Stock ...
        RowLayout {
            width: parent.width
            spacing: Theme.xsSpacing

            DsLabel {
                text: qsTr("Enforce stock quantity update on sales")
                fontSize: Theme.baseFontSize
                color: Theme.txtPrimaryColor
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            DsIconButton {
                iconType: IconType.infoCircle
                width: Theme.xsBtnheight
                height: width
                radius: height/2
                iconSize: width*0.5
                textColor: hovered ? Theme.txtPrimaryColor : Theme.txtHintColor
                bgColor: "transparent"
                bgHover: Utils.withOpacity(Theme.baseAlt2Color, 0.8)
                bgDown: Utils.withOpacity(Theme.baseAlt2Color, 0.6)
                Layout.alignment: Qt.AlignVCenter
                toolTip: qsTr("What's this?")
            }

            DsSwitch {
                id: stockswitch
                checked: true
                bgColor: Theme.bodyColor
                inactiveColor: Theme.baseAlt3Color
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }

}
