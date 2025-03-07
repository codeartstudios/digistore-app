import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import app.digisto.modules

import "../controls"

DsPopup {
    id: popup
    width: 400
    height: col.height + Theme.baseSpacing
    closePolicy: Popup.NoAutoClose
    modal: true

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
        border.width: 1
        border.color: Theme.baseAlt1Color
    }

    contentItem: Item {
        Column {
            id: col
            width: parent.width-2*Theme.baseSpacing
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            Item {
                height: Theme.btnHeight
                width: parent.width

                Rectangle {
                    height: 1
                    width: parent.width
                    color: Theme.baseAlt1Color
                    anchors.bottom: parent.bottom
                }

                RowLayout {
                    anchors.fill: parent
                    spacing: Theme.xsSpacing

                    DsLabel {
                        id: infolabel
                        fontSize: Theme.xlFontSize
                        color: Theme.txtPrimaryColor
                        height: Theme.btnHeight
                        elide: DsLabel.ElideRight
                        leftPadding: Theme.xsSpacing
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                    }

                    DsIconButton {
                        textColor: Theme.txtPrimaryColor
                        bgColor: "transparent"
                        bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                        bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                        iconType: IconType.x

                        Layout.alignment: Qt.AlignVCenter
                        onClicked: popup.close()
                    }
                }
            }

            DsLabel {
                id: desclabel
                width: parent.width
                fontSize: Theme.lgFontSize
                color: Theme.txtPrimaryColor
                wrapMode: DsLabel.WordWrap
                padding: Theme.smSpacing
            }
        }
    }
}
