import QtQuick
import QtQuick.Controls.Basic
import app.digisto.modules

ToolTip {
    id: control
    text: qsTr("")
    delay: 1000
    timeout: 5000
    width: row.width + Theme.xsSpacing
    height: 36

    x: (side===DsToolTip.Top || side===DsToolTip.Bottom) ?
           0 : side===DsToolTip.Right ?
               edgeSpacing + parentWidth :
               -(edgeSpacing + width)

    y: side===DsToolTip.Top ?
           -edgeSpacing : side===DsToolTip.Bottom ?
               (edgeSpacing+parentHeight) :
               (parentHeight-height)/2

    property real parentWidth: parent.width
    property real parentHeight: parent.height
    property real edgeSpacing: Theme.xsSpacing
    property int side: DsToolTip.Right
    property alias bgRect: bg

    enum Side {
        Left,
        Right,
        Top,
        Bottom
    }

    contentItem: Item {
        Row {
            id: row
            anchors.centerIn: parent

            DsLabel {
                text: control.text
                fontSize: Theme.baseFontSize
                color: Theme.baseColor
                leftPadding: Theme.btnRadius
                rightPadding: Theme.btnRadius
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    background: Rectangle {
        id: bg
        radius: Theme.btnRadius
        color: Theme.tooltipColor

        // Upward pointing arrow
        DsIcon {
            iconType: IconType.triangleFilled
            color: parent.color
            iconSize: Theme.h3
            rotation: 0
            visible: side===DsToolTip.Bottom
            anchors.bottom: parent.top
            anchors.left: parent.left
            anchors.leftMargin: Theme.btnRadius
            anchors.bottomMargin: -Theme.btnRadius
        }

        // Downward pointing indicator
        DsIcon {
            iconType: IconType.triangleFilled
            color: parent.color
            iconSize: Theme.h3
            rotation: 180
            visible: side===DsToolTip.Top
            anchors.top: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: Theme.btnRadius
        }

        // Right pointing arrow
        DsIcon {
            iconType: IconType.triangleFilled
            color: parent.color
            iconSize: Theme.h3
            rotation: 90
            visible: side===DsToolTip.Left
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: -Theme.btnRadius
        }

        DsIcon {
            iconType: IconType.triangleFilled
            color: parent.color
            iconSize: Theme.h3
            rotation: -90
            visible: side===DsToolTip.Right
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.left
            anchors.rightMargin: -Theme.btnRadius
        }
    }
}
