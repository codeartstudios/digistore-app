import QtQuick
import Qt5Compat.GraphicalEffects
import app.digisto.modules

Item {
    id: root
    implicitHeight: 200
    implicitWidth: 200

    property alias shadowColor: ds.color
    property alias background: bg
    property alias horizontalOffset: ds.horizontalOffset
    property alias verticalOffset: ds.verticalOffset
    property alias radius: ds.radius

    Rectangle {
        id: bg
        color: Theme.bodyColor
        anchors.fill: parent
        visible: false
    }

    DropShadow {
        id: ds
        anchors.fill: bg
        horizontalOffset: 3
        verticalOffset: 3
        radius: 8.0
        color: Theme.shadowColor
        source: bg
    }
}
