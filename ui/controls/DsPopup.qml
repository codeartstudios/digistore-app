import QtQuick
import QtQuick.Controls.Basic
import app.digisto.modules

import "../controls"

Popup {
    id: root
    implicitWidth: 200
    implicitHeight: 100
    x: getXCoord(mainApp.width, width)
    y: getYCoord(mainApp.height, height)
    closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape

    property alias radius: bg.radius
    property alias backgroundColor: bg.color
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

    // ------------------------------------------------------- //
    // Functions to compute the precise x,y cord that makes    //
    // the popup centered correctly.                           //
    // ------------------------------------------------------- //
    function getXCoord(appW, itemW) {
        var localPos = mapToItem(mainApp.contentItem, 0,0)
        var centerX = (appW - itemW) / 2;
        return centerX - localPos.x
    }

    function getYCoord(appH, itemH) {
        var localPos = mapToItem(mainApp.contentItem, 0,0)
        var centerY = (appH - itemH) / 2;
        return centerY - localPos.y;
    }
}
