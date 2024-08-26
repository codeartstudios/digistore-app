import QtQuick
import QtQuick.Controls.Basic
import app.digisto.modules

Button {
    id: control
    enabled: !busy
    implicitHeight: Theme.btnHeight
    implicitWidth: row.width + 2*Theme.xsSpacing

    property bool busy: false
    property string iconType
    property real fontSize: Theme.baseFontSize
    property real radius: bg.radius
    property string textColor: Theme.baseColor
    property string bgColor: Theme.primaryColor

    background: Rectangle {
        id: bg
        color: bgColor
        radius: Theme.btnRadius
        opacity: enabled ? (hovered ? 0.8 : down ? 0.6 : 1) : 0.4
    }

    contentItem: Item {
        anchors.fill: parent

        Row {
            id: row
            spacing: Theme.xsSpacing
            anchors.centerIn: parent

            DsIcon {
                id: ico
                visible: iconType!==""
                iconType: busy ? IconType.loader2 : control.iconType ? control.iconType : ""
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
