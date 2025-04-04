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

        actions: [
            DsIconButton {
                height: Theme.btnHeight
                width: height
                iconType: IconType.pencil
                radius: height/2
                textColor: hovered ? Theme.txtPrimaryColor : Theme.txtHintColor
                bgColor: 'transparent'
                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                toolTip: qsTr("Edit Organization")
                toolTipSide: DsToolTip.Side.Bottom
                anchors.verticalCenter: parent.verticalCenter

                onClicked: openDrawer(1)
            }
        ]

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
    }

    DsSettingsCard {
        width: parent.width
        title: qsTr("Workspace")
        desc: qsTr("Organization workspace details.")

        actions: [
            DsIconButton {
                height: Theme.btnHeight
                width: height
                iconType: IconType.pencil
                radius: height/2
                textColor: hovered ? Theme.txtPrimaryColor : Theme.txtHintColor
                bgColor: 'transparent'
                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                toolTip: qsTr("Edit Organization")
                toolTipSide: DsToolTip.Side.Bottom
                anchors.verticalCenter: parent.verticalCenter

                onClicked: openDrawer(1)
            }
        ]

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
    }

    DsSettingsCard {
        width: parent.width
        title: qsTr("Preferences")
        desc: qsTr("Organization defined settings.")

        actions: [
            DsIconButton {
                height: Theme.btnHeight
                width: height
                iconType: IconType.pencil
                radius: height/2
                textColor: hovered ? Theme.txtPrimaryColor : Theme.txtHintColor
                bgColor: 'transparent'
                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                toolTip: qsTr("Edit Organization")
                toolTipSide: DsToolTip.Side.Bottom
                anchors.verticalCenter: parent.verticalCenter

                onClicked: openDrawer(1)
            }
        ]

        // Currency
        DsSettingsRowLabel {
            label: qsTr("Default currency")
            value: orgCurrency &&
                   orgCurrency.cc ?
                       `${orgCurrency.name} (${orgCurrency.symbol})` : "--"
        }

        // Lock timeout
        DsSettingsRowLabel {
            label: qsTr("Applock Timeout Enabled (10 minutes)")
            value: dsController.organization.settings &&
                   dsController.organization.settings.screen_timeout_enabled ?
                       qsTr("True") : qsTr("False")
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
