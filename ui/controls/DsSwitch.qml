import QtQuick
import QtQuick.Controls.Basic
import app.digisto.modules

Rectangle {
    id: root
    implicitHeight: Theme.inputHeight
    width: height * 2
    radius: height/2
    color: Theme.baseColor
    opacity: enabled ? 1 : 0.7
    border.width: Theme.btnRadius/2
    border.color: Theme.shadowColor

    property bool checked: false
    property alias bgColor: root.color
    property string activeColor: Theme.successColor
    property string inactiveColor: Theme.successAltColor
    property alias idicator: indicator

    Rectangle {
        id: indicator
        width: height
        radius: height/2
        height: root.height - Theme.btnRadius
        anchors.verticalCenter: parent.verticalCenter
        x: root.checked ? root.width - width - Theme.btnRadius/2 : Theme.btnRadius/2
        color: root.checked ? root.activeColor : root.inactiveColor

        Behavior on color { ColorAnimation {} }
        Behavior on x { NumberAnimation {} }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: if(root.enabled) checked = !checked
    }
}
