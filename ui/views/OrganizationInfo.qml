import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

import "../controls"
import "../popups"

DsSettingsStackPage {
    id: scrollview

    property DsMessageBox messageBox: DsMessageBox{}

    // Organization Details
    DsSettingsCard {
        width: parent.width
        title: qsTr("Organization")
        desc: qsTr("Organization information.")

        DsSettingsRowLabel {
            label: qsTr("Org. Name")
            value: dsController.organization.name
        }

        DsSettingsRowLabel {
            label: qsTr("Org. Description")
            value: dsController.organization.description
        }

        DsSettingsRowLabel {
            label: qsTr("Org. Email")
            value: dsController.organization.email
        }

        DsSettingsRowLabel {
            label: qsTr("Org. Mobile")
            value: formatMobile(dsController.organization.mobile)

            function formatMobile(mobile) {
                if(!mobile || mobile==="") return ""
                return `(${mobile.dial_code})${mobile.number}`
            }
        }

        DsSettingsRowLabel {
            label: qsTr("Org. Website")
            value: dsController.organization.domain
        }

        DsSettingsRowLabel {
            label: qsTr("Org. Address")
            value: dsController.organization.address
        }

        // Add Separator line
        Rectangle {
            width: parent.width
            height: 1
            color: Theme.baseAlt1Color
        } // Separator Line

        // Workspace
        DsSettingsRowLabel {
            label: qsTr("Workspace Name")
            value: dsController.organization.workspace
        }

        // Domain
        DsSettingsRowLabel {
            label: qsTr("Workspace URL")
            value: dsController.organization.workspace_url
        }

        DsSettingsRowLabel {
            label: qsTr("Workspace Approved")
            value: dsController.organization.approved
        }

        // Add Separator line
        Rectangle {
            width: parent.width
            height: 1
            color: Theme.baseAlt1Color
        } // Separator Line

        // Currency
        DsSettingsRowLabel {
            label: qsTr("Default currency")
            value: dsController.organization.settings &&
                   dsController.organization.settings.currency ?
                       dsController.organization.settings.currency : ""
        }

        // Lock timeout
        DsSettingsRowLabel {
            label: qsTr("App lock timeout")
            value: dsController.organization.settings &&
                   dsController.organization.settings.applock ?
                       dsController.organization.settings.applock : ""
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
            dsController.organization = data
        }

        else if(res.status === 403) {
            showMessage("Access Error",
                        "Only admins can access this action.")
        }

        else {
            showMessage("Organization Error",
                        `${res.data.message ? res.data.message : qsTr("Unknown Error!")}`)
        }
    }

    Component.onCompleted: fetchOrganizationDetails()
}
