import QtQuick
import QtQuick.Controls
import app.digisto.modules

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

    DsToast{ id: toast}

    background: Rectangle {
        id: bg
        color: Theme.bodyColor
        // radius: Theme.btnRadius

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
                textColor: Theme.warningColor
                bgColor: "transparent"
                bgHover: withOpacity(Theme.warningAltColor, 0.8)
                bgDown: withOpacity(Theme.warningAltColor, 0.6)
                anchors.left: parent.left
                anchors.leftMargin: Theme.btnRadius/2
                anchors.verticalCenter: parent.verticalCenter

                onClicked: root.close()
            }
        }
    }
}
