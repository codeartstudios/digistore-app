import QtQuick
import app.digisto.modules

Item {
    id: root
    implicitHeight: Theme.btnHeight
    implicitWidth: Theme.btnHeight

    property bool running: false

    function start() { running=true }
    function stop() { running=false }

    DsIcon {
        id: ico
        iconType: IconType.loader2
        anchors.centerIn: parent
    }

    RotationAnimation {
        target: ico
        duration: 1000
        running: root.running
        from: 0
        to: 360
        loops: RotationAnimation.Infinite
    }
}
