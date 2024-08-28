import QtQuick
import app.digisto.modules
import "../controls"

Item {
    id: root

    property alias loader: mainloader
    property alias active: mainloader.active
    property alias asynchronous: mainloader.asynchronous
    property alias item: mainloader.item
    property alias progress: mainloader.progress
    property alias source: mainloader.source
    property alias sourceComponent: mainloader.sourceComponent
    property alias status: mainloader.status
    property alias busyComponent: busyloader.sourceComponent
    property alias busySource: busyloader.source

    Loader {
        id: mainloader
        visible: status===Loader.Ready
        anchors.fill: parent
    }

    Loader {
        id: busyloader
        visible: mainloader.status===Loader.Loading
        sourceComponent: Component {
            Rectangle {
                color: Theme.baseColor
                visible: busyloader.visible

                DsBusyIndicator {
                    width: 100
                    height: 100
                    running: true
                    anchors.centerIn: parent
                }
            }
        }

        anchors.fill: parent
    }
}
