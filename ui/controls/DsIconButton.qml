import QtQuick
import QtQuick.Controls.Basic

Button {
    id: control
    enabled: !busy
    implicitHeight: theme.btnHeight
    implicitWidth: theme.btnHeight
    height: implicitHeight
    width: implicitWidth
    hoverEnabled: true

    property bool busy: false
    property string iconType
    property alias iconSize: ico.iconSize
    property alias radius: bg.radius
    property alias toolTip: tooltip.text
    property alias toolTipSide: tooltip.side
    property bool toolTipShown: true
    property string textColor: theme.baseColor
    property string bgColor: theme.primaryColor
    property string bgHover: withOpacity(bgColor, 0.8)
    property string bgDown: withOpacity(bgColor, 0.6)

    background: Rectangle {
        id: bg
        color: down ? bgDown : hovered ? bgHover : bgColor
        radius: theme.btnRadius
        opacity: enabled ? 1 : 0.4
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

    DsToolTip {
        id: tooltip
        parent: control
        visible: toolTipShown && parent.hovered && text!==""
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
