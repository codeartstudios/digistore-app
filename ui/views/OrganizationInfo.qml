import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

import "../controls"
import "../popups"

DsSettingsStackPage {
    id: scrollview

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

        DsSettingsRowLabel {
            label: qsTr("Org. Name")
            value: qsTr("Some Org Inc.")
        }

        DsSettingsRowLabel {
            label: qsTr("Org. Description")
            value: qsTr("Some Org Inc.")
        }

        DsSettingsRowLabel {
            label: qsTr("Org. Email")
            value: qsTr("email@org.com")
        }

        DsSettingsRowLabel {
            label: qsTr("Org. Mobile")
            value: qsTr("+1 234 456 789")
        }

        DsSettingsRowLabel {
            label: qsTr("Org. Website")
            value: qsTr("https://someorg.com")
        }

        // Add Separator line

        // Workspace
        DsSettingsRowLabel {
            label: qsTr("Workspace URL")
            value: qsTr("xxxx.digisto.app")
        }

        // Domain
        DsSettingsRowLabel {
            label: qsTr("Server Root Domain")
            value: qsTr("https://digisto.app")
        }

        // Currency
        DsSettingsRowLabel {
            label: qsTr("Default currency")
            value: qsTr("Kenyan Shilling (KSH)")
        }

        // Lock timeout
        DsSettingsRowLabel {
            label: qsTr("App lock timeout")
            value: qsTr("1 Minute")
        }
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

    function openDrawer(page) {
        switch(page) {
        case "pocketbase": {
            orgpbadminDrawer.open()
            break;
        }

        case "settings": {
            orgsettingsDrawer.open()
            break;
        }

        case "accounts": {
            orgaccountsDrawer.open()
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

    // Component.onCompleted: fetchOrganizationDetails()
}
