import QtQuick
import app.digisto.modules

import "../popups"

Item {
    id: _page
    property string title: qsTr("New Page")
    property bool awaitingRequest: false

    property var navigationStack
    property bool headerShown: true
    property var navigationHeader
    property bool headerTitleShown: true

    property Requests request: Requests {
        token: dsController.token
        baseUrl: dsController.baseUrl
    }

    property DsMessageBox messageBox: DsMessageBox{ // TODO
        x: (_page.width-width)/2 // - _page.mapToGlobal(0, 0).x
        y: (_page.height-height)/2 // - _page.mapToGlobal(0, 0).y
    }

    function showMessage(title="", info="") {
        messageBox.title = title
        messageBox.info = info
        messageBox.open()
    }
}
