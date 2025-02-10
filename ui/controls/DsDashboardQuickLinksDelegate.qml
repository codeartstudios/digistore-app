import QtQuick
import QtQuick.Layouts
import app.digisto.modules

Item {
    id: root
    width: parent.width
    height: Theme.inputHeight

    property alias text: label.text

    // Mouse actions signals & properties
    property bool hovered: false
    property bool down: false
    signal clicked

    MouseArea {
        id: ma
        anchors.fill: parent
        onEntered: parent.hovered=true
        onExited: parent.hovered=false
        hoverEnabled: true
        onClicked: parent.clicked()

        Binding{ root.down: ma.pressed }
    }

    RowLayout {
        anchors.fill: parent
        spacing: Theme.xsSpacing
        clip: true

        DsLabel {
            id: label
            fontSize: Theme.smFontSize
            color: Theme.txtPrimaryColor
            isUnderlined: root.hovered
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        DsIcon {
            iconSize: root.hovered ?
                          Theme.baseFontSize : 0
            iconColor: Theme.txtPrimaryColor
            iconType: IconType.chevronRight
            Layout.alignment: Qt.AlignVCenter

            Behavior on iconSize { NumberAnimation { easing.type: Easing.InOutQuad }}
        }
    }
}

