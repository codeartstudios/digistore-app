import QtQuick
import QtQuick.Controls.Basic
import app.digisto.modules

import "../controls"
import "../js/main.js" as DsMain

DsPopup {
    id: root
    y: mainApp.height - height - Theme.xsSpacing
    x: Theme.appSidebarWidth * 0.8
    width: 200
    implicitHeight: col.height + Theme.smSpacing
    padding: 1
    borderColor: Theme.shadowColor
    borderWidth: 1
    closePolicy: DsPopup.CloseOnPressOutside || DsPopup.CloseOnEscape

    contentItem: Item {
        Column {
            id: col
            width: parent.width - Theme.smSpacing
            spacing: Theme.btnRadius
            anchors.centerIn: parent

            DsLabel {
                text: getLabel(dsController.loggedUser.name)
                color: Theme.txtPrimaryColor
                fontSize: Theme.baseFontSize
                width: parent.width
                elide: DsLabel.ElideRight
            }

            DsLabel {
                text: qsTr('Role') + `: <b>${getLabel(dsController.loggedUser.role)}</b>`
                color: Theme.txtHintColor
                fontSize: Theme.smFontSize
                width: parent.width
                elide: DsLabel.ElideRight
                textFormat: DsLabel.RichText
                bottomPadding: Theme.smSpacing
            }

            DsButton {
                bgColor: Theme.dangerAltColor
                endIcon: IconType.arrowNarrowRight
                text: qsTr("Log Out")
                textColor: Theme.dangerColor
                width: parent.width
                height: Theme.smBtnHeight

                onClicked: {
                    root.close()
                    DsMain.logout()
                }
            }
        }
    }

    function getLabel(data) {
        if(!data || data==='') return qsTr('<none>')
        return Utils.toSentenceCase(data)
    }
}
