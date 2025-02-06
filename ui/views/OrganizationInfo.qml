import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

import "settings/controls"
import "../controls"
import "../popups"

ScrollView {
    id: scrollview

    // ScrollBar.horizontal: ScrollBar{
    //     policy: ScrollBar.AlwaysOff
    // }

    // Keys.onUpPressed: scrollBar.decrease()
    // Keys.onDownPressed: scrollBar.increase()

    // ScrollBar.vertical: ScrollBar{
    //     id: scrollBar
    //     policy: ScrollBar.AsNeeded
    //     parent: scrollview
    //     anchors.top: scrollview.top
    //     anchors.bottom: scrollview.bottom
    //     anchors.left: scrollview.right
    // }

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


    Column {
        id: _contentCol
        width: scrollview.width
        spacing: Theme.xsSpacing

        // Organization Details
        DsSettingsCard {
            width: _contentCol.width
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
            title: qsTr("Organization Admin Actions")
            desc: qsTr("Configure administrative actions")

            RowLayout {
                width: parent.width
                spacing: Theme.xsSpacing

                DsLabel {
                    text: qsTr("View & Manage User Accounts")
                    fontSize: Theme.baseFontSize
                    color: Theme.txtPrimaryColor
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                }

                DsButton {
                    text: qsTr("User Accounts")
                    endIcon: IconType.externalLink
                    height: Theme.xsBtnheight
                    textColor: Theme.baseColor
                    Layout.alignment: Qt.AlignVCenter

                    onClicked: openDrawer("accounts")
                }
            }

            // or
            RowLayout {
                width: parent.width
                spacing: Theme.xsSpacing

                DsLabel {
                    text: qsTr("Change Organization Settings")
                    fontSize: Theme.baseFontSize
                    color: Theme.txtPrimaryColor
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                }

                DsButton {
                    text: qsTr("Org. Settings")
                    endIcon: IconType.externalLink
                    height: Theme.xsBtnheight
                    textColor: Theme.baseColor
                    Layout.alignment: Qt.AlignVCenter

                    onClicked: openDrawer("settings")
                }
            }

            RowLayout {
                width: parent.width
                spacing: Theme.xsSpacing

                DsLabel {
                    text: qsTr("Open Pocketbase Admin Panel")
                    fontSize: Theme.baseFontSize
                    color: Theme.txtPrimaryColor
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                }

                DsButton {
                    text: qsTr("Pocketbase Dashboard")
                    endIcon: IconType.externalLink
                    height: Theme.xsBtnheight
                    textColor: Theme.baseColor
                    Layout.alignment: Qt.AlignVCenter

                    onClicked: openDrawer("pocketbase")
                }
            }
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

    Loader {
        id: drawerLoader
        asynchronous: true
    }

    function openDrawer(page) {
        switch(page) {
        case "accounts": {
            drawerLoader.source = "qrc:/ui/popups/DsOrgUserAccountDrawer.qml";
            drawerLoader.active = true;
            break;
        }

        case "settings": {
            drawerLoader.source = "qrc:/ui/popups/DsOrgSettingsDrawer.qml";
            drawerLoader.active = true;
            break;
        }

        case "accounts": {
            drawerLoader.source = "qrc:/ui/popups/DsOrgPocketbaseAdminDrawer.qml";
            drawerLoader.active = true;
            break;
        }
        }
    }

    function fetchOrganizationDetails() {
        request.clear()
        request.token = dsController.token
        request.baseUrl = dsController.baseUrl
        request.path = `/api/collections/organization/records/${dsController.workspaceId}`
        var res = request.send();

        if(res.status===200) {
            var data = res.data;
            orgName = data.name
            orgDescription = data.description
            orgEmail = data.email
            orgAddress = data.address
            orgMobile = data.mobile
            orgId = data.id;
            orgBanner = data.banner
            orgLogo = data.logo
            orgDomain = data.domain
            orgActivated = data.approved
            orgCreated = data.created
        }

        else if(res.status === 403) {
            showMessage("Access Error",
                        "Only admins can access this action.")
        }

        else {
            showMessage("Organization Error",
                        "The requested resource wasn't found.")
        }
    }

    Component.onCompleted: fetchOrganizationDetails()
}
