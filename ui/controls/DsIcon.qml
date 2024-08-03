import QtQuick
import QtQuick.Controls

Item {
    implicitHeight: iconSize
    implicitWidth: iconSize

    property real iconSize: 18
    required property string iconType
    property string color: theme.txtPrimaryColor

    Label {
        color: parent.color
        text: iconType
        font.pixelSize: iconSize
        font.family: tablerIconsFontLoader.name
        verticalAlignment: Label.AlignVCenter
        horizontalAlignment: Label.AlignHCenter
        anchors.centerIn: parent
    }
}
