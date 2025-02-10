import QtQuick
import app.digisto.modules

Rectangle {
    id: root
    x: (mainApp.width - width)/2
    y: root.opened ? 2 * height : -height
    z: 99 // Always show on top of all controls
    visible: y > -height
    height: Theme.btnHeight
    radius: height/2
    width: row.width > mainApp.width ? mainApp.width : row.width + 2
    color: type===DsToast.Type.INFO ?
               Theme.infoAltColor : type===DsToast.Type.SUCCESS ?
                   Theme.successAltColor : type===DsToast.Type.WARNING ?
                       Theme.warningAltColor : Theme.dangerAltColor

    Behavior on y { NumberAnimation { easing.type: Easing.InOutQuad }}
    Behavior on width { NumberAnimation { easing.type: Easing.InOutQuad }}
    Behavior on color { ColorAnimation { easing.type: Easing.InOutQuad }}

    enum Type {
        INFO,
        WARNING,
        SUCCESS,
        ERROR
    }

    enum Timeout {
        STICKY = 0,
        SHORT = 3500,
        MEDIUM = 5500,
        LONG = 10000
    }

    function open(_message, _type = DsToast.Type.INFO, _timeout = DsToast.Timeout.SHORT) {
        message = _message
        type = _type
        timeout = _timeout
        timer.restart()
        opened = true
    }

    function info(_message, _timeout = DsToast.Timeout.SHORT) {
        open(_message, DsToast.Type.INFO, _timeout)
    }

    function success(_message, _timeout = DsToast.Timeout.SHORT) {
        open(_message, DsToast.Type.SUCCESS, _timeout)
    }

    function warning(_message, _timeout = DsToast.Timeout.MEDIUM) {
        open(_message, DsToast.Type.WARNING, _timeout)
    }

    function error(_message, _timeout = DsToast.Timeout.STICKY) {
        open(_message, DsToast.Type.ERROR, _timeout)
    }

    function close() {
        opened = false
        clear()
    }

    function clear() {
        message = ""
    }

    property bool opened: false
    property alias message: msg.text
    property int type: DsToast.Type.INFO
    property int timeout: DsToast.Timeout.SHORT
    property string foreColor: type===DsToast.Type.INFO ?
                                   Theme.infoColor : type===DsToast.Type.SUCCESS ?
                                       Theme.successColor : type===DsToast.Type.WARNING ?
                                           Theme.warningColor : Theme.dangerColor

    Timer {
        id: timer
        running: timeout > 0 && root.opened
        interval: timeout
        repeat: false
        onTriggered: if(timeout!==DsToast.Timeout.STICKY)
                         root.close()
    }

    Row {
        id: row
        spacing: Theme.xsSpacing/2
        height: Theme.btnHeight - 2
        anchors.centerIn: parent

        DsIcon {
            height: Theme.btnHeight - 2
            width: height
            iconSize: height/2
            iconColor: root.foreColor
            iconType: type===DsToast.Type.INFO ?
                          IconType.infoCircle : type===DsToast.Type.SUCCESS ?
                              IconType.circleDashedCheck : type===DsToast.Type.WARNING ?
                                  IconType.alertCircle : IconType.alertTriangle
            anchors.verticalCenter: parent.verticalCenter
        }

        DsLabel {
            id: msg
            text: "!"
            fontSize: Theme.smFontSize
            color: root.foreColor
            anchors.verticalCenter: parent.verticalCenter
        }

        DsButton {
            id: closeBtn
            height: Theme.btnHeight - 2
            width: height
            bgColor: root.color
            textColor: root.foreColor
            radius: height/2
            onHoveredChanged: icoRotAnim.restart()

            // Close the message
            onClicked: root.close()

            contentItem: Item {
                DsIcon {
                    id: ico
                    iconType: IconType.x
                    iconSize: closeBtn.fontSize * 1.2
                    iconColor: closeBtn.textColor
                    anchors.centerIn: parent

                    RotationAnimation {
                        id: icoRotAnim
                        target: ico
                        from: closeBtn.hovered ? 0 : 180
                        to: closeBtn.hovered ? 180 : 0
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }
}
