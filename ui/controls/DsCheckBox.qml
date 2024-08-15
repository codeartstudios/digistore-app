import QtQuick
import QtQuick.Controls.Basic

CheckBox {
    id: control
    checked: true
    width: size
    height: size

    property real size: theme.btnHeight

    indicator: Rectangle {
        implicitWidth: 26
        implicitHeight: 26
        color: "transparent"
        radius: theme.btnRadius
        border.color: checked ? control.down ? "#17a81a" : "#21be2b" : theme.txtDisabledColor

        anchors.centerIn: parent

        Rectangle {
            width: 14
            height: 14
            x: 6
            y: 6
            radius: 2
            color: control.down ? "#17a81a" : "#21be2b"
            visible: control.checked
        }
    }
}
