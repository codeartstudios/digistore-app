import QtQuick
import QtWebView
import app.digisto.modules

import "../controls"

DsDrawer {
    id: root
    width: mainApp.width * 0.9
    modal: true

    property bool webviewLoading: false
    property real webviewLoadingProgress: 0

    onWebviewLoadingChanged: console.log(`WebView Loading? `, webviewLoading)
    onWebviewLoadingProgressChanged: console.log(`WebView Loading Progress: ${webviewLoadingProgress} `)

    Loader {
        id: webviewloader
        asynchronous: true
        active: root.opened
        anchors.fill: parent

        WebView {
            id: webview
            anchors.fill: parent
            url: `${dsController.baseUrl}/_/`

            // Bind properties in webview to those outside
            Binding { root.webviewLoading: webview.loading }
            Binding { root.webviewLoadingProgress: webview.loadProgress }
        }
    }

    DsBusyIndicator {
        running: webviewloader.status===Loader.Loading || webviewLoading
        visible: running
        anchors.fill: parent
    }
}
