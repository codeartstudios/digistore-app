import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import app.digisto.modules

Button {
    id: control
    implicitHeight: Theme.btnHeight
    implicitWidth: row.width + 3*Theme.smSpacing
    height: implicitHeight
    width: implicitWidth
    hoverEnabled: !active
    checkable: true
    checked: active

    property string iconType: IconType.arrowsMoveVertical
    property alias iconSize: ico.iconSize
    property alias radius: bg.radius
    property alias toolTip: tooltip.text
    property alias toolTipSide: tooltip.side
    property bool active: false
    property bool toolTipShown: true
    property string textColor: Theme.txtPrimaryColor
    property string bgColor: "transparent"
    property string bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
    property string bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

    background: Item {
        clip: true

        Rectangle {
            id: bg
            width: parent.width
            height: parent.height + radius
            color: ( down || checked )? Theme.baseAlt1Color : hovered ? bgHover : bgColor
            radius: Theme.btnRadius
            opacity: enabled ? 1 : 0.4
        }
    }

    contentItem: Item {
        anchors.fill: parent

        Row {
            id: row
            spacing: Theme.xsSpacing
            anchors.centerIn: parent

            DsIcon {
                id: ico
                iconType: control.iconType
                iconSize: lbl.fontSize * 1.3
                iconColor: lbl.color
                anchors.verticalCenter: parent.verticalCenter
            }

            DsLabel {
                id: lbl
                fontSize: control.font.pixelSize
                fontWeight: Font.DemiBold
                color: Theme.txtHintColor
                text: control.text
                elide: DsLabel.ElideRight
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    DsToolTip {
        id: tooltip
        x: 0
        y: control.height - Theme.btnRadius
        side: DsToolTip.Bottom
        text: control.text
        parent: control
        visible: parent.hovered && text!==""
    }
}
