import QtQuick

Rectangle {
    id: root
    implicitWidth: 200
    implicitHeight: 150
    color: theme.baseColor
    border.width: 1
    border.color: theme.baseAlt1Color
    radius: theme.btnRadius

    property alias label: _label.text
    property alias value: _value.text
    property alias units: _unit.text

    signal clicked()

    Item {
        id: _topheading
        height: theme.btnHeight
        width: parent.width
        anchors.top: parent.top

        Rectangle {
            height: 1
            width: parent.width
            color: theme.baseAlt1Color
            anchors.bottom: parent.bottom
        }

        DsLabel {
            id: _label
            fontSize: theme.h2
            height: theme.btnHeight
            leftPadding: theme.xsSpacing
            verticalAlignment: DsLabel.AlignVCenter
        }

        DsIconButton {
            textColor: theme.txtPrimaryColor
            bgColor: "transparent"
            bgHover: withOpacity(theme.baseAlt1Color, 0.8)
            bgDown: withOpacity(theme.baseAlt1Color, 0.6)
            iconType: dsIconType.arrowRight
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
        anchors.leftMargin: theme.xsSpacing
        anchors.rightMargin: theme.xsSpacing

        DsLabel {
            id: _value
            fontSize: theme.lgBtnHeight
            anchors.verticalCenter: parent.verticalCenter

            DsLabel {
                id: _unit
                fontSize: theme.baseFontSize
                anchors.left: parent.right
                anchors.baseline: parent.baseline
            }
        }
    }
}

