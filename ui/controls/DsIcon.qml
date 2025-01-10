import QtQuick
import QtQuick.Controls
import app.digisto.modules

Item {
    implicitHeight: iconSize
    implicitWidth: iconSize

    property real iconSize: 18
    required property string iconType
    property string color: Theme.txtPrimaryColor
    property alias label: lbl

    Label {
        id: lbl
        color: parent.color
        text: iconType
        font.pixelSize: iconSize
        font.family: tablerIconsFontLoader.name
        verticalAlignment: Label.AlignVCenter
        horizontalAlignment: Label.AlignHCenter
        anchors.centerIn: parent
    }
}
