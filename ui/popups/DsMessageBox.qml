import QtQuick
import QtQuick.Controls.Basic
import app.digisto.modules

import "../controls"

Popup {
    id: popup
    width: 400
    height: col.height + Theme.baseSpacing
    closePolicy: Popup.NoAutoClose
    modal: true
    x: (mainApp.width-width)/2 - mapToGlobal(0, 0).x
    y: (mainApp.height-height)/2 - mapToGlobal(0, 0).y

    property string primaryText: qsTr("Ok")
    property string secondaryText: qsTr("Cancel")

    property alias title: infolabel.text
    property alias info: desclabel.text

    signal accepted()
    signal cancelled()

    onCancelled: popup.close()
    onAccepted: popup.close()

    background: Rectangle {
        radius: Theme.xsSpacing
        color: Theme.bodyColor
    }

    contentItem: Item {
        Column {
            id: col
            spacing: 0
            width: parent.width-2*Theme.baseSpacing
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: Theme.baseSpacing
            anchors.leftMargin: Theme.baseSpacing
            anchors.rightMargin: Theme.baseSpacing

            DsLabel {
                id: infolabel
                visible: infolabel.text!==''
                width: parent.width
                fontSize: Theme.lgFontSize
                color: Theme.txtPrimaryColor
                wrapMode: DsLabel.WordWrap
                bottomPadding: Theme.smSpacing
            }

            DsLabel {
                id: desclabel
                visible: desclabel.text!==''
                width: parent.width
                fontSize: Theme.smFontSize
                color: Theme.txtPrimaryColor
                wrapMode: DsLabel.WordWrap
                bottomPadding: Theme.baseSpacing
            }

            Item {
                width: popup.width
                height: Theme.lgBtnHeight + Theme.xsSpacing
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true

                Rectangle {
                    radius: Theme.xsSpacing
                    width: parent.width
                    height: parent.height + Theme.xsSpacing
                    color: Theme.baseColor
                    anchors.bottom: parent.bottom
                }

                Row {
                    spacing: Theme.smSpacing
                    height: Theme.btnHeight
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.baseSpacing
                    anchors.verticalCenter: parent.verticalCenter

                    DsButton {
                        id: cancelBtn
                        text: secondaryText
                        textColor: Theme.txtPrimaryColor
                        bgColor: "transparent"
                        bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                        bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                        onClicked: popup.cancelled()
                    }

                    DsButton {
                        id: acceptedBtn
                        text: primaryText
                        textColor: Theme.primaryColor
                        bgColor: Theme.warningAltColor
                        onClicked: popup.accepted()
                    }
                }
            }
        }
    }
}
