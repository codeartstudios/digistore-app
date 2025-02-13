import QtQuick
import QtQuick.Controls.Basic
import app.digisto.modules

Button {
    id: root
    implicitHeight: Theme.btnHeight
    implicitWidth: Theme.btnHeight
    width: Theme.lgBtnHeight
    height: width
    hoverEnabled: true
    iconSize: 28

    // Flag whether the menu is selected
    property bool isActive: false

    property string iconType: IconType.point
    property alias iconSize: ico.iconSize
    property alias radius: bg.radius

    // Tooltip
    property alias toolTip: tooltip.text
    property alias toolTipSide: tooltip.side
    property bool toolTipShown: true

    // Border
    property real borderWidth:      0
    property string borderColor:    Theme.txtPrimaryColor

    // Text & Background colors
    property string iconColor:  isActive ? Theme.txtPrimaryColor : withOpacity(Theme.txtPrimaryColor, 0.6)
    property string bgColor:    isActive ? Theme.baseAlt1Color : "transparent"
    property string bgHover:    withOpacity(Theme.baseAlt1Color, 0.8)
    property string bgDown:     withOpacity(Theme.baseAlt1Color, 0.6)

    onClicked: {
        // Set current label if checkable is set to `true`
        if(model.checkable)
            globalModels.currentSideBarMenu = model.label

        // Emit signal
        menuSelected(model.label)
    }

    background: Rectangle {
        id: bg
        color: root.enabled ? (down ? bgDown : hovered ? bgHover : bgColor) : bgColor
        radius: Theme.btnRadius
        opacity: root.enabled ? 1 : 0.4
        border.color: borderColor
        border.width: borderWidth

        Rectangle {
            id: indicator
            visible: root.isActive
            radius: width/2
            color: Theme.primaryColor
            height: visible ? 0.5 * root.height : 0
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

    contentItem: Item {
        anchors.fill: parent

        DsIcon {
            id: ico
            opacity: root.enabled ? 1 : 0.4
            width: root.iconSize
            iconType: root.iconType===null ? "" : root.iconType
            iconSize: 19
            iconColor: root.iconColor
            anchors.centerIn: parent
        }
    }

    DsToolTip {
        id: tooltip
        parent: root
        visible: toolTipShown && parent.hovered && text!==""
    }


    onIsActiveChanged: isActive ? indicator.fadeIn() :
                                  indicator.fadeOut()
}
