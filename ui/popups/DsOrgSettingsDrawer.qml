import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

import "../controls"
import "../popups"

DsDrawer {
    id: root
    width: mainApp.width * 0.9
    modal: true

    property string orgName: ""
    property string orgDescription: ""
    property string orgEmail: ""
    property string orgAddress: ""
    property string orgMobile: ""
    property string orgId: ""
    property string orgBanner: ""
    property string orgLogo: ""
    property string orgDomain: ""
    property string orgCreated: ""
    property bool orgActivated: false
    property DsMessageBox messageBox: DsMessageBox{}

    ColumnLayout {
        anchors.fill: parent
        spacing: Theme.smSpacing

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.lgBtnHeight
            Layout.leftMargin: Theme.baseSpacing
            Layout.rightMargin: Theme.baseSpacing
            Layout.topMargin: Theme.smSpacing
            spacing: Theme.smSpacing

            DsLabel {
                fontSize: Theme.h1
                color: Theme.txtHintColor
                text: qsTr("Organization")
                Layout.alignment: Qt.AlignVCenter
            }

            DsLabel {
                fontSize: Theme.h1
                color: Theme.txtHintColor
                text: qsTr("/")
                Layout.alignment: Qt.AlignVCenter
            }

            DsLabel {
                fontSize: Theme.h2
                color: Theme.txtPrimaryColor
                text: qsTr("Users")
                Layout.alignment: Qt.AlignVCenter
            }

            DsIconButton {
                // enabled: !getaccountsrequest.running
                iconType: IconType.reload
                textColor: Theme.txtPrimaryColor
                bgColor: "transparent"
                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                radius: height/2
                Layout.alignment: Qt.AlignVCenter

                onClicked: getTellers()
            }

            Item {
                Layout.fillWidth: true
                height: 1
            }

            DsMenu {
                id: accountsMenu
                iconType: IconType.pencilCog
                text: qsTr("Account Options")

                Component.onCompleted: {
                    menuModel.append({type: "", icon: IconType.usersPlus, label: qsTr("New User")})
                    menuModel.append({type: "spacer" })
                    menuModel.append({type: "", icon: IconType.userCog, label: qsTr("Account Settings")})
                }
            }
        }

        DsSearchInputNoPopup {
            id: dsSearchInput
            // busy: getaccountsrequest.running
            placeHolderText: qsTr("Who are you looking for?")
            Layout.preferredHeight: Theme.lgBtnHeight
            Layout.fillWidth: true
            Layout.leftMargin: Theme.baseSpacing
            Layout.rightMargin: Theme.baseSpacing

            onAccepted: (txt) => getTellers()
        }

        DsSettingsStackPage {
            id: scrollview
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: Theme.baseSpacing
            Layout.rightMargin: Theme.baseSpacing

            // Organization Details
            DsSettingsCard {
                width: parent.width
                title: qsTr("Organization")
                desc: qsTr("Organization details and subscription plan.")

                actions: [
                    DsButton {
                        text: qsTr("Update Org.")
                        visible: false
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
                        text: orgEmail
                        label: qsTr("Org. Email")
                        color: Theme.bodyColor
                        input.placeholderText: qsTr("email@org.com")
                        Layout.fillWidth: true
                    }

                    DsInputWithLabel {
                        id: orgmobileinput
                        text: orgMobile
                        label: qsTr("Org. Mobile")
                        color: Theme.bodyColor
                        input.placeholderText: qsTr("+1 234 456 789")
                        Layout.fillWidth: true
                    }

                    DsInputWithLabel {
                        id: orgwebsiteinput
                        text: orgDomain
                        label: qsTr("Org. Website")
                        color: Theme.bodyColor
                        input.placeholderText: qsTr("https://someorg.com")
                        Layout.fillWidth: true
                    }
                }
            }

            // Organization Settings
            DsSettingsCard {
                width: parent.width
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
                width: parent.width
                text: qsTr("Product Settings")
                fontSize: Theme.baseFontSize
                color: Theme.txtPrimaryColor
            }

            // Organization Settings
            DsSettingsCard {
                width: parent.width
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
    }
}
