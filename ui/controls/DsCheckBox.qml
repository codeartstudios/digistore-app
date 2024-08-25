import QtQuick
import QtQuick.Controls.Basic
import app.digisto.modules

CheckBox {
    id: control
    checked: true
    width: cbSize
    height: cbSize

    property real cbSize: Theme.btnHeight
    property real boxSize: 26

    indicator: Rectangle {
        implicitWidth: boxSize
        implicitHeight: boxSize
        color: "transparent"
        radius: Theme.btnRadius
        border.color: checked ? control.down ? "#17a81a" : "#21be2b" : Theme.txtDisabledColor

        anchors.centerIn: parent

        Rectangle {
            width: boxSize/2 + 2
            height: boxSize/2 + 2
            radius: 2
            color: control.down ? "#17a81a" : "#21be2b"
            visible: control.checked
            anchors.centerIn: parent
        }
    }
}
