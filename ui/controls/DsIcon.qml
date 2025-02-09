import QtQuick
import QtQuick.Controls
import app.digisto.modules

Item {
    id: root
    implicitHeight: iconSize
    implicitWidth: iconSize

    // Alias of the icon size in `px`
    property real iconSize: Theme.xlFontSize

    // Icon to be displayed, string expected from font icon
    required property string iconType

    // Font color
    property string color: Theme.txtPrimaryColor

    // Alias to the label showing the icon
    property alias label: lbl

    Label {
        id: lbl
        color: parent.color
        text: iconType
        font.pixelSize: root.iconSize
        font.family: tablerIconsFontLoader.name
        verticalAlignment: Label.AlignVCenter
        horizontalAlignment: Label.AlignHCenter
        anchors.centerIn: parent
        visible: root.iconSize > 0
    }
}
