import QtQuick
import QtQuick.Controls.Basic
import app.digisto.modules

Button {
    id: control
    enabled: !busy
    implicitHeight: Theme.btnHeight
    implicitWidth: Theme.btnHeight
    height: implicitHeight
    width: implicitWidth
    hoverEnabled: true

    property bool busy: false
    property string iconType
    property alias iconSize: ico.iconSize
    property alias radius: bg.radius
    property real borderWidth: 0
    property string borderColor: Theme.txtPrimaryColor
    property alias toolTip: tooltip.text
    property alias toolTipSide: tooltip.side
    property bool toolTipShown: true
    property string textColor: Theme.baseColor
    property string bgColor: Theme.primaryColor
    property string bgHover: withOpacity(bgColor, 0.8)
    property string bgDown: withOpacity(bgColor, 0.6)

    background: Rectangle {
        id: bg
        color: down ? bgDown : hovered ? bgHover : bgColor
        radius: Theme.btnRadius
        opacity: enabled ? 1 : 0.4
        border.color: borderColor
        border.width: borderWidth
    }

    contentItem: Item {
        anchors.fill: parent

        DsIcon {
            id: ico
            width: visible ? 0 : iconSize
            visible: iconType!==undefined || iconType!==""
            iconType: busy ? IconType.rotate2 : control.iconType===null ? "" : control.iconType
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
