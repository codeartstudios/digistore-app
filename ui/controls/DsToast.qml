import QtQuick
import QtQuick.Layouts
import app.digisto.modules

Rectangle {
    id: root
    x: (mainApp.width - width)/2
    y: root.opened ? Theme.lgBtnHeight : -height
    z: 99 // Always show on top of all controls
    visible: y > -height
    height: Math.max(Theme.btnHeight, item.height + Theme.xsSpacing)
    radius: Theme.btnRadius
    width: 400
    border.width: 1
    border.color: internal.foreColor
    color: internal.backgroundColor

    // Animation behaviour
    Behavior on y       { NumberAnimation   { easing.type: Easing.InOutQuad }}
    Behavior on width   { NumberAnimation   { easing.type: Easing.InOutQuad }}
    Behavior on color   { ColorAnimation    { easing.type: Easing.InOutQuad }}

    property bool opened: false
    property alias message: msg.text
    property int type: DsToast.Type.INFO
    property int timeout: DsToast.Timeout.SHORT
    property string foreColor: internal.foreColor

    Item {
        id: item
        height: Math.max(Theme.btnHeight, col.height)
        width: parent.width - 4
        anchors.centerIn: parent

        DsIcon {
            id: _ico
            height: Theme.btnHeight
            width: height
            iconSize: height/2
            iconColor: root.foreColor
            iconType: internal.icon

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            id: col
            anchors.left: _ico.right
            anchors.right: _closebtn.left
            anchors.verticalCenter: parent.verticalCenter

            DsLabel {
                id: msg
                text: "!"
                fontSize: Theme.smFontSize
                color: root.foreColor
                width: parent.width
                wrapMode: DsLabel.WordWrap
            }
        }

        DsButton {
            id: _closebtn
            height: Theme.btnHeight
            width: height
            bgColor: root.color
            textColor: root.foreColor
            radius: height/2
            onHoveredChanged: icoRotAnim.restart()

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            // Close the message
            onClicked: root.close()

            contentItem: Item {
                DsIcon {
                    id: ico
                    iconType: IconType.x
                    iconSize: _closebtn.fontSize * 1.2
                    iconColor: _closebtn.textColor
                    anchors.centerIn: parent

                    RotationAnimation {
                        id: icoRotAnim
                        target: ico
                        from: _closebtn.hovered ? 0 : 180
                        to: _closebtn.hovered ? 180 : 0
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }

    Timer {
        id: timer
        running: timeout > 0 && root.opened
        interval: timeout
        repeat: false
        onTriggered: if(timeout!==DsToast.Timeout.STICKY)
                         root.close()
    }

    QtObject {
        id: internal

        property string icon: type===DsToast.Type.INFO ?
                                  IconType.infoCircle : type===DsToast.Type.SUCCESS ?
                                      IconType.circleDashedCheck : type===DsToast.Type.WARNING ?
                                          IconType.alertCircle : IconType.alertTriangle

        property string foreColor: type===DsToast.Type.INFO ?
                                       Theme.infoColor : type===DsToast.Type.SUCCESS ?
                                           Theme.successColor : type===DsToast.Type.WARNING ?
                                               Theme.warningColor : Theme.dangerColor

        property string backgroundColor: type===DsToast.Type.INFO ?
                                             Theme.infoAltColor : type===DsToast.Type.SUCCESS ?
                                                 Theme.successAltColor : type===DsToast.Type.WARNING ?
                                                     Theme.warningAltColor : Theme.dangerAltColor
    }

    // ---------------------------------------------------------------- //
    // CONTROL ENUMs
    // ---------------------------------------------------------------- //

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

    // ---------------------------------------------------------------- //
    // HELPER FUNCTIONS
    // ---------------------------------------------------------------- //

    function open(_message, _type = DsToast.Type.INFO, _timeout = DsToast.Timeout.SHORT) {
        message = _message
        type = _type
        timeout = _timeout
        timer.restart()
        opened = true
        console.log('Opening toast, message -> ', _message)
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
        console.log('Closing ...')
    }

    function clear() {
        message = ""
    }
}
