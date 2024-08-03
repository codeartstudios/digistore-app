import QtQuick
import QtQuick.Controls

Item {
    implicitHeight: iconSize
    implicitWidth: iconSize

    property real iconSize: 18
    required property string iconType
    property string color: theme.foreground

    Label {
        text: iconType
        font.pixelSize: iconSize
        font.family: tablerIconsFontLoader.name
        anchors.centerIn: parent
    }
}
