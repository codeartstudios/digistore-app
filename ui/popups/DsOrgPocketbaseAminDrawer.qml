import QtQuick
import QtWebView
import app.digisto.modules

import "../controls"

DsDrawer {
    id: root
    width: mainApp.width * 0.9
    modal: true

    WebView {
        id: webview
        anchors.fill: parent
        url: `${dsController.baseUrl}/_/`
    }

    DsBusyIndicator {
        running: webview.loading
        visible: running
        anchors.fill: parent
    }
}
