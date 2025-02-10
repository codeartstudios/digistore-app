import QtQuick
import QtQuick.Controls
import app.digisto.modules

Item {
    id: root
    clip: true
    implicitHeight: iconSize
    implicitWidth: iconSize

    // Alias of the icon size in `px`
    property real iconSize: Theme.xlFontSize

    // Icon to be displayed, string expected from font icon
    property string iconType: ''

    // Icon color
    property string iconColor: Theme.txtPrimaryColor

    Label {
        id: lbl
        color: root.iconColor
        text: root.iconType
        font.pixelSize: root.iconSize
        font.family: tablerIconsFontLoader.name
        verticalAlignment: Label.AlignVCenter
        horizontalAlignment: Label.AlignHCenter
        anchors.centerIn: parent
    }
}
