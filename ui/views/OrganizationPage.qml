import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

import "../controls"
import "../popups"
import "../flow"

DsPage {
    id: root
    title: qsTr("Organization Page")
    headerShown: true

    property ListModel orgTabModel: ListModel{}

    property alias orgpbadminDrawer: orgpbadminDrawer
    property alias orgaccountsDrawer: orgaccountsDrawer
    property alias orgsettingsDrawer: orgsettingsDrawer

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

            // Reload button
            DsIconButton {
                id: refreshBtn
                enabled: !request.running
                iconType: IconType.reload
                textColor: Theme.txtPrimaryColor
                bgColor: "transparent"
                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                radius: height/2
                Layout.alignment: Qt.AlignVCenter

                onClicked: organizationinfopage.fetchOrganizationDetails()
            }

            Item {
                Layout.fillWidth: true
                height: 1
            }

            // Admin actions in the organization context
            DsMenu {
                id: toolsMenu
                iconType: IconType.shieldCog
                text: qsTr("Admin Actions")
                menuPopup.width: width * 1.3
                onCurrentMenuChanged: (index) => openDrawer(index)

                // Create the menu options, append to the ListModel used
                // to populate the menus
                Component.onCompleted: {
                    menuModel.clear()

                    menuModel.append({
                                         label: "Manage User Accounts",
                                         icon: IconType.users
                                     })

                    menuModel.append({
                                         label: "Edit Organization",
                                         icon: IconType.adjustmentsCog
                                     })

                    menuModel.append({ type: "spacer" })

                    menuModel.append({
                                         label: "Pocketbase Admin Panel",
                                         icon: IconType.shieldLock
                                     })
                }
            }

        }

        StackView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: Theme.baseSpacing
            Layout.rightMargin: Theme.baseSpacing
            Layout.bottomMargin: Theme.baseSpacing

            initialItem: OrganizationInfo {
                id: organizationinfopage
            }
        }
    }

    DsOrgSettingsDrawer {
        id: orgsettingsDrawer

        fetchOrganizationInProgess: request.running
        onReloadOrganization: organizationinfopage.fetchOrganizationDetails()
    }
    DsOrgUserAccountDrawer { id: orgaccountsDrawer }
    DsOrgPocketbaseAminDrawer { id: orgpbadminDrawer }

    function openDrawer(ind) {
        switch(ind) {
        case 3: {
            if(!dsPermissionManager.isAdmin) {
                showPermissionDeniedWarning(toast)
                return
            }

            orgpbadminDrawer.open()
            break;
        }

        case 1: {
            if(!dsPermissionManager.canUpdateOrganization) {
                showPermissionDeniedWarning(toast)
                return
            }

            orgsettingsDrawer.open()
            break;
        }

        case 0: {
            if(!dsPermissionManager.canViewUserAccounts) {
                showPermissionDeniedWarning(toast)
                return
            }

            orgaccountsDrawer.open()
            break;
        }
        }
    }
}
