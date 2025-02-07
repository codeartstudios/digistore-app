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

            DsIconButton {
                id: refreshBtn
                iconType: IconType.reload
                textColor: Theme.txtPrimaryColor
                bgColor: "transparent"
                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                radius: height/2
                Layout.alignment: Qt.AlignVCenter

                // onClicked: root.refreshPage()
            }

            Item {
                Layout.fillWidth: true
                height: 1
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

    DsOrgSettingsDrawer {id: orgsettingsDrawer }
    DsOrgUserAccountDrawer { id: orgaccountsDrawer }
    DsOrgPocketbaseAminDrawer { id: orgpbadminDrawer }
}
