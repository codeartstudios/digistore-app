import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Button {
    id: control
    implicitHeight: theme.btnHeight
    implicitWidth: theme.btnHeight
    height: implicitHeight
    width: implicitWidth
    hoverEnabled: true
    enabled: sortable

    property string iconType: dsIconType.arrowsMoveVertical
    property alias iconSize: ico.iconSize
    property alias radius: bg.radius
    property alias toolTip: tooltip.text
    property alias toolTipSide: tooltip.side
    property bool sortable: true
    property bool toolTipShown: true
    property string textColor: theme.txtPrimaryColor
    property string bgColor: "transparent"
    property string bgHover: withOpacity(theme.baseAlt1Color, 0.8)
    property string bgDown: withOpacity(theme.baseAlt1Color, 0.6)

    background: Item {
        clip: true

        Rectangle {
            id: bg
            width: parent.width
            height: parent.height + radius
            color: down ? bgDown : hovered ? bgHover : bgColor
            radius: theme.btnRadius
            opacity: enabled ? 1 : 0.4
        }
    }

    contentItem: Item {
        anchors.fill: parent

        RowLayout {
            id: row
            anchors.fill: parent

            DsLabel {
                id: lbl
                fontSize: control.font.pixelSize
                font.weight: 600
                color: theme.txtHintColor
                text: control.text
                elide: DsLabel.ElideRight
                leftPadding: theme.smSpacing
                rightPadding: theme.btnRadius
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            DsIcon {
                id: ico
                visible: control.sortable
                iconType: control.iconType
                iconSize: visible ? lbl.fontSize : 0
                color: lbl.color
                Layout.preferredWidth: theme.smSpacing + lbl.fontSize
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }

    DsToolTip {
        id: tooltip
        x: 0
        y: control.height - theme.btnRadius
        text: control.text
        parent: control
        visible: parent.hovered && text!==""
    }
}
