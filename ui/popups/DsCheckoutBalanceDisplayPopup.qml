import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.platform
import QtQuick.Controls.Basic
import app.digisto.modules

import "../controls"

Popup {
    id: root
    width: 600
    height: 400
    modal: true
    x: (parent.width-width)/2
    y: (parent.height-height)/2
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    // Passed in balance amount
    property real balanceDue: 0

    background: Rectangle {
        color: Theme.bodyColor
        radius: Theme.btnRadius

        MouseArea {
            focus: true
            anchors.fill: parent
            onClicked: root.close()
            Keys.onEscapePressed: root.close()
            Keys.onEnterPressed: root.close()
        }
    }

    contentItem: Item {
        anchors.fill: parent

        DsLabel {
            fontSize: Theme.baseFontSize
            color: Theme.txtHintColor
            text: qsTr("Click anywhere to close")

            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.smSpacing
            anchors.horizontalCenter: parent.horizontalCenter
        }


        Column {
            spacing: Theme.baseSpacing
            anchors.centerIn: parent

            DsLabel {
                fontSize: Theme.h1
                color: Theme.txtHintColor
                text: qsTr("Customer Balance")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsLabel {
                fontSize: 48
                isBold: true
                color: Theme.txtHintColor
                text: `KES. ${root.balanceDue}`
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
