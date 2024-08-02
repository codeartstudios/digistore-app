import QtQuick

Window {
    width: 640
    height: 480
    visibility: "Maximized"
    visible: true

    property alias tablerIconsFontLoader: tablerIconsFontLoader

    FontLoader {
        id: tablerIconsFontLoader
        source: "qrc:/assets/fonts/tabler-icons.ttf"
    }
}
