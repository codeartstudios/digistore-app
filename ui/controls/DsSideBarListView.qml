import QtQuick
import app.digisto.modules

ListView {
    id: root
    spacing: Theme.btnRadius
    delegate: DsIconButton {
        property bool isActive: currentSideBarMenu===model.label

        iconType: model.iconType
        toolTip: model.tooltip
        width: Theme.lgBtnHeight
        height: width
        iconSize: 28
        bgColor: isActive ? Theme.baseAlt1Color : "transparent"
        bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
        bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
        textColor: isActive ? Theme.txtPrimaryColor : withOpacity(Theme.txtPrimaryColor, 0.6)
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: {
            if(model.checkable) currentSideBarMenu = model.label
            menuSelected(model.label)
        }

        onIsActiveChanged: isActive ? indicator.fadeIn() :
                                      indicator.fadeOut()

        Rectangle {
            id: indicator
            visible: parent.isActive
            radius: width/2
            color: Theme.primaryColor
            height: visible ? 0.5 * parent.height : 0
            width: Theme.btnRadius
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            Behavior on height { NumberAnimation {} }

            function fadeIn() { fadein.restart() }
            function fadeOut() { fadeout.restart() }

            OpacityAnimator {
                id: fadein
                target: indicator
                from: 0; to: 1
            }

            OpacityAnimator {
                id: fadeout
                target: indicator
                from: 1; to: 0
            }
        }
    }
}
