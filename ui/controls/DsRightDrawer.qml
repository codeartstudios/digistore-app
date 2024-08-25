import QtQuick
import QtQuick.Controls.Basic
import app.digisto.modules

Drawer {
    id: drawer

    implicitWidth: 300
    implicitHeight: mainApp.height

    modal: true
    edge: Qt.RightEdge
    closePolicy: "NoAutoClose"

    property alias radius: bg.radius
    property alias border: bg.border
    property alias bgColor: bg.color

    background: Rectangle {
        id: bg
        anchors.fill: parent

        // Add close button on the top left edge/corner
        Rectangle {
            implicitHeight: 36
            implicitWidth: implicitHeight*2
            color: parent.color
            radius: height/2

            anchors.top: parent.top
            anchors.right: parent.left
            anchors.topMargin: 20
            anchors.rightMargin: -height

            Item {
                anchors.fill: parent
                anchors.rightMargin: height

                DsIcon {
                    iconSize: 24
                    iconType: IconType.x
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: drawer.close()
                }
            }
        }
    }
}
