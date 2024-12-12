import QtQuick
import app.digisto.modules

import "../popups"

Item {
    property string title: qsTr("New Page")
    property bool awaitingRequest: false

    property var navigationStack
    property bool headerShown: true
    property var navigationHeader
    property bool headerTitleShown: true

    property Requests request: Requests{}
    property DsMessageBox messageBox: DsMessageBox{}

    function showMessage(title="", info="") {
        messageBox.title = title
        messageBox.info = info
        messageBox.open()
    }
}
