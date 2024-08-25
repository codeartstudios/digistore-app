import QtQuick
import app.digisto.modules

Rectangle {
    id: root
    implicitWidth: 200
    implicitHeight: 150
    color: Theme.baseColor
    border.width: 1
    border.color: Theme.baseAlt1Color
    radius: Theme.btnRadius

    property alias label: _label.text
    property alias value: _value.text
    property alias units: _unit.text

    signal clicked()

    Item {
        id: _topheading
        height: Theme.btnHeight
        width: parent.width
        anchors.top: parent.top

        Rectangle {
            height: 1
            width: parent.width
            color: Theme.baseAlt1Color
            anchors.bottom: parent.bottom
        }

        DsLabel {
            id: _label
            fontSize: Theme.h2
            height: Theme.btnHeight
            leftPadding: Theme.xsSpacing
            verticalAlignment: DsLabel.AlignVCenter
        }

        DsIconButton {
            textColor: Theme.txtPrimaryColor
            bgColor: "transparent"
            bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
            bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
            iconType: IconType.arrowRight
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right

            onClicked: root.clicked()
        }
    }

    Item {
        anchors.top: _topheading.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Theme.xsSpacing
        anchors.rightMargin: Theme.xsSpacing

        DsLabel {
            id: _value
            fontSize: Theme.lgBtnHeight
            anchors.verticalCenter: parent.verticalCenter

            DsLabel {
                id: _unit
                fontSize: Theme.baseFontSize
                anchors.left: parent.right
                anchors.baseline: parent.baseline
            }
        }
    }
}

