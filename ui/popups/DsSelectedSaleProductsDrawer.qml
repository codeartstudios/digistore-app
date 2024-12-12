import QtQuick
import QtQuick.Controls
import app.digisto.modules

Drawer {
    id: root
    width: 400
    height: mainApp.height
    edge: Qt.RightEdge
    modal: true

    property var dataModel: null

    background: Rectangle {
        color: Theme.bodyColor
        // radius: Theme.btnRadius

        Rectangle {
            height: Theme.btnHeight
            width: Theme.btnHeight + Theme.btnHeight/2
            color: parent.color
            anchors.top: parent.top
            anchors.right: parent.left
            anchors.rightMargin: -Theme.btnHeight/2
        }
    }

    contentItem: Item {
        anchors.fill: parent
    }
}
