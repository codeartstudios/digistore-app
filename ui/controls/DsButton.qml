import QtQuick
import QtQuick.Controls.Basic

Button {
    id: control
    enabled: !busy
    implicitHeight: theme.btnHeight
    implicitWidth: row.width + 2*theme.xsSpacing

    property bool busy: false
    property string iconType
    property real fontSize: theme.baseFontSize
    property real radius: bg.radius
    property string textColor: theme.baseColor
    property string bgColor: theme.primaryColor

    background: Rectangle {
        id: bg
        color: bgColor
        radius: theme.btnRadius
        opacity: enabled ? (hovered ? 0.8 : down ? 0.6 : 1) : 0.4
    }

    contentItem: Item {
        anchors.fill: parent

        Row {
            id: row
            spacing: theme.xsSpacing
            anchors.centerIn: parent

            DsIcon {
                id: ico
                visible: iconType!==""
                iconType: busy ? dsIconType.rotate2 : control.iconType ? control.iconType : ""
                iconSize: fontSize
                color: control.textColor
                anchors.verticalCenter: parent.verticalCenter
            }

            DsLabel {
                fontSize: control.fontSize
                color: control.textColor
                text: control.text
                anchors.verticalCenter: parent.verticalCenter
            }
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
