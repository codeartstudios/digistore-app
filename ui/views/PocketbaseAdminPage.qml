import QtQuick
import QtQuick.Controls.Basic
// import QtWebView

import "../controls"

Window {
    id: root
    width: mainApp.width * 0.7
    height: mainApp.height * 0.7
    x: (mainApp.width-width)/2
    y: (mainApp.height-height)/2
    title: qsTr("Pocketbase Admin")
    // WebView {
    //     anchors.fill: parent
    //     url: `http://127.0.0.1:8090/_/`
    // }
}
