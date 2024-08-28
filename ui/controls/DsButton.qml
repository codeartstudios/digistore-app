import QtQuick
import QtQuick.Controls.Basic
import app.digisto.modules

Button {
    id: control
    enabled: !busy
    implicitHeight: Theme.btnHeight
    implicitWidth: row.width + 2*Theme.smSpacing
    height: implicitHeight
    width: implicitWidth

    property bool busy: false
    property string iconType
    property alias endIcon: endicon.iconType
    property real fontSize: Theme.baseFontSize
    property real radius: bg.radius
    property bool toolTipShown: true
    property alias tooltipText: tooltip.text
    property alias tooltip: tooltip
    property string textColor: Theme.baseColor
    property string bgColor: Theme.primaryColor
    property string bgHover: withOpacity(bgColor, 0.8)
    property string bgDown: withOpacity(bgColor, 0.6)
    property real borderWidth: 0
    property string borderColor: Theme.primaryColor

    background: Rectangle {
        id: bg
        color: control.enabled ? (down ? bgDown : hovered ? bgHover : bgColor) : bgColor
        radius: Theme.btnRadius
        border.width: borderWidth
        border.color: borderColor
        opacity: control.enabled ? 1 : 0.4
    }

    contentItem: Item {
        Row {
            id: row
            spacing: Theme.xsSpacing
            anchors.centerIn: parent

            DsIcon {
                id: ico
                visible: iconType!==""
                iconType: busy ? IconType.loader2 : control.iconType ? control.iconType : ""
                iconSize: control.fontSize * 1.2
                color: control.textColor
                anchors.verticalCenter: parent.verticalCenter
            }

            DsLabel {
                fontSize: control.fontSize
                color: control.textColor
                text: control.text
                anchors.verticalCenter: parent.verticalCenter
            }

            DsIcon {
                id: endicon
                iconType: ""
                visible: iconType!==""
                iconSize: control.fontSize * 1.2
                color: control.textColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    DsToolTip {
        id: tooltip
        parent: control
        visible: toolTipShown && parent.hovered && text!==""
        side: DsToolTip.Bottom
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
