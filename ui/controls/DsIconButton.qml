import QtQuick
import QtQuick.Controls.Basic

Button {
    id: control
    enabled: !busy
    implicitHeight: theme.btnHeight
    implicitWidth: theme.btnHeight

    property bool busy: false
    property string iconType
    property alias iconSize: ico.iconSize
    property real radius: bg.radius
    property string textColor: theme.baseColor
    property string bgColor: theme.primaryColor
    property string bgHover: bgColor

    background: Rectangle {
        id: bg
        color: enabled ? hovered ? bgHover : bgColor : bgColor
        radius: theme.btnRadius
        opacity: enabled ? (hovered ? 0.8 : down ? 0.6 : 1) : 0.4

        Behavior on color { NumberAnimation {} }
    }

    contentItem: Item {
        anchors.fill: parent

        DsIcon {
            id: ico
            width: visible ? 0 : iconSize
            visible: iconType!==undefined || iconType!==""
            iconType: busy ? dsIconType.rotate2 : control.iconType===null ? "" : control.iconType
            iconSize: 19
            color: control.textColor
            anchors.centerIn: parent
        }
    }

    RotationAnimation {
        target: ico
        from: 0
        to: 360
        duration: 800
        running: busy

        onRunningChanged: if(!running) ico.rotation = 0
    }
}
