import QtQuick
import QtQuick.Controls.Basic
import app.digisto.modules

import "../controls"

Popup {
    id: root
    implicitWidth: 200
    implicitHeight: 100
    x: (mainApp.width-width)/2
    y: (mainApp.height-height)/2
    closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape

    property alias radius: bg.radius
    property alias borderColor: bg.borderColor
    property alias borderWidth: bg.borderWidth
    property bool closeDelayElapsed: true

    onClosed: {
        closeDelayElapsed = false;
        timer.start()
    }

    Timer {
        id: timer
        interval: 500
        repeat: false
        running: false
        onTriggered: closeDelayElapsed=true
    }

    background: Rectangle {
        id: bg
        property real borderWidth: 0
        property string borderColor: "#000"

        color: Theme.bodyColor
        radius: Theme.btnRadius
        border.color: borderColor
        border.width: borderWidth
    }
}
