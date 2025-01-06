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

    background: Rectangle {
        color: Theme.bodyColor
        radius: Theme.btnRadius
    }
}
