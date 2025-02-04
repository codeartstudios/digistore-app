import QtQuick
import QtQuick.Layouts
import app.digisto.modules

import "controls" // Settings
import "../../controls"

// TODO must confirm email/mobile number
DsSettingsStackPage {
    id: root
    title: qsTr("Organization")

    // Organization Details
    DsSettingsCard {
        title: qsTr("Organization")
        desc: qsTr("Organization details and subscription plan.")

        actions: [
            DsButton {
                text: qsTr("Update Org.")
            },

            DsButton {
                text: qsTr("Upgrade Plan")
                bgColor: Theme.warningColor
                textColor: Theme.baseColor
                endIcon: IconType.arrowUpRight
            }

        ]

        RowLayout {
            width: parent.width
            spacing: Theme.xsSpacing

            DsInputWithLabel {
                id: orgnameinput
                label: qsTr("Org. Website")
                color: Theme.bodyColor
                input.placeholderText: qsTr("Some Org Inc.")
                Layout.fillWidth: true
            }

            DsInputWithLabel {
                id: orgdescinput
                label: qsTr("Org. Description")
                color: Theme.bodyColor
                input.placeholderText: qsTr("Some Org Inc.")
                Layout.fillWidth: true
            }
        }

        RowLayout {
            width: parent.width
            spacing: Theme.xsSpacing

            DsInputWithLabel {
                id: orgemailinput
                label: qsTr("Org. Email")
                color: Theme.bodyColor
                input.placeholderText: qsTr("email@org.com")
                Layout.fillWidth: true
            }

            DsInputWithLabel {
                id: orgmobileinput
                label: qsTr("Org. Mobile")
                color: Theme.bodyColor
                input.placeholderText: qsTr("+1 234 456 789")
                Layout.fillWidth: true
            }

            DsInputWithLabel {
                id: orgwebsiteinput
                label: qsTr("Org. Website")
                color: Theme.bodyColor
                input.placeholderText: qsTr("https://someorg.com")
                Layout.fillWidth: true
            }
        }


        Rectangle {
            width: parent.width
            radius: Theme.btnRadius
            height: plancol.height + Theme.xsSpacing * 2
            color: Theme.warningAltColor

            RowLayout {
                width: parent.width - Theme.xsSpacing * 2
                spacing: Theme.xsSpacing
                anchors.centerIn: parent

                Column {
                    id: plancol
                    spacing: Theme.xsSpacing/2
                    Layout.fillWidth: true

                    DsLabel {
                        color: Theme.txtHintColor
                        fontSize: Theme.smFontSize
                        text: qsTr("Current Plan")
                    }

                    DsLabel {
                        color: Theme.txtHintColor
                        fontSize: Theme.h3
                        text: qsTr("STARTER")
                        isBold: true
                    }
                }

                Column {
                    spacing: Theme.xsSpacing/2
                    Layout.fillWidth: true

                    DsLabel {
                        color: Theme.txtHintColor
                        fontSize: Theme.smFontSize
                        text: qsTr("Expires")
                    }

                    DsLabel {
                        color: Theme.txtHintColor
                        fontSize: Theme.h3
                        text: qsTr("NEVER")
                        isBold: true
                    }
                }
            }
        }
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
                // text: dsController.
                Layout.minimumWidth: 300
            }
        }

        // Currency
        RowLayout {
            width: parent.width
            spacing: Theme.xsSpacing

            DsLabel {
                text: qsTr("Workspace default currency")
                fontSize: Theme.baseFontSize
                color: Theme.txtPrimaryColor
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            DsComboBox {
                id: currecycb
                height: Theme.inputHeight + Theme.xsSpacing
                radius: Theme.btnRadius
                bgColor: Theme.bodyColor
                model: [qsTr("Kenyan Shilling (KSH)"), qsTr("US Dollar ($)")]
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
