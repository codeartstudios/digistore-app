import QtQuick
import QtQuick.Controls
import app.digisto.modules

import "../popups"

Drawer {
    id: root
    width: 400
    height: mainApp.height
    edge: Qt.RightEdge
    modal: true
    closePolicy: Drawer.NoAutoClose

    property alias bgrect: bg
    property alias topCloseButtonShown: clsbtn.visible
    property alias toast : toast

    property Requests request: Requests {
        token: dsController.token
        baseUrl: dsController.baseUrl
    }

    property DsMessageBox messageBox: DsMessageBox{ // TODO
        x: (root.width-width)/2 // - root.mapToGlobal(0, 0).x
        y: (root.height-height)/2 // - root.mapToGlobal(0, 0).y

        function showMessage(title="", info="") {
            messageBox.title = title
            messageBox.info = info
            messageBox.open()
        }
    }

    function showMessage(title="", info="") {
        messageBox.showMessage(title, info)
    }

    DsToast{ id: toast}

    background: Rectangle {
        id: bg
        color: Theme.bodyColor

        Rectangle {
            id: clsbtn
            height: Theme.btnHeight
            width: Theme.btnHeight + Theme.btnHeight/2
            color: parent.color
            radius: height/2
            anchors.top: parent.top
            anchors.right: parent.left
            anchors.topMargin: Theme.btnHeight/2
            anchors.rightMargin: -Theme.btnHeight/2

            DsIconButton {
                height: parent.height - Theme.btnRadius
                width: height
                iconType: IconType.x
                radius: height/2
                textColor: Theme.dangerColor
                bgColor: Theme.dangerAltColor
                toolTip: qsTr("Close")
                anchors.left: parent.left
                anchors.leftMargin: Theme.btnRadius/2
                anchors.verticalCenter: parent.verticalCenter

                onClicked: root.close()
            }
        }
    }
}
