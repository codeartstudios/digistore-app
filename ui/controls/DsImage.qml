import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: root
    implicitHeight: 100
    implicitWidth: 100

    property real radius: 0
    property alias source: img.source
    property alias fillMode: img.fillMode

    Image {
        id: img
        width: root.width
        height: root.height
        fillMode: Image.PreserveAspectCrop
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: mask
        }
    }

    Rectangle {
        id: mask
        width: root.width
        height: root.width
        radius: root.radius
        visible: false
    }
}
