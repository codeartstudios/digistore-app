import QtQuick
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Basic
import app.digisto.modules

DsButton {
    id: root
    endIcon: IconType.caretDown

    property ListModel model: ListModel {}
    property alias menuPopup: popup

    // Signal emitted when the current menu index changes
    signal currentMenuChanged(index: var)

    // Open the menu popup options when we hover over the button
    onClicked: if(hovered) popup.open()

    Popup {
        id: popup
        implicitWidth: 200
        height: menulv.height + Theme.smSpacing/2
        x: root.width - popup.width
        y: root.height + Theme.smSpacing

        background: Item {
            Rectangle {
                id: bgRect
                color: Theme.bodyColor
                anchors.fill: parent
                visible: false
            }

            DropShadow {
                anchors.fill: bgRect
                horizontalOffset: 3
                verticalOffset: -3
                radius: 8.0
                color: Theme.baseAlt3Color
                source: bgRect
            }

            DsIcon {
                id: ico
                visible: false
                iconType: IconType.dropletFilled
                color: Theme.bodyColor
                iconSize: Theme.baseSpacing
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: -iconSize*2/3
            }

            DropShadow {
                anchors.fill: ico
                horizontalOffset: 3
                verticalOffset: -3
                radius: 8.0
                color: Theme.baseAlt3Color
                source: ico
            }

            Rectangle {
                color: Theme.bodyColor
                width: parent.width
                height: parent.height
            }
        }

        contentItem: Item {
            anchors.fill: parent

            ListView {
                id: menulv
                clip: true
                model: root.model
                width: popup.width - Theme.btnRadius
                height: Theme.btnHeight * root.model.count
                anchors.centerIn: parent
                delegate: DsButton {
                    id: _menudelegate
                    width: menulv.width
                    height: Theme.btnHeight
                    leftIconShown: true
                    iconType: model.icon
                    text: model.label
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                    onClicked: {
                        // Close the menu popup first so that consecutive
                        // executions dont leave the popup hanging
                        popup.close()

                        // Emit index changed
                        root.currentMenuChanged(index)
                    }

                    contentItem: Item {
                        Row {
                            id: row
                            spacing: Theme.xsSpacing
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left

                            DsIcon {
                                id: ico
                                visible: leftIconShown
                                iconType: _menudelegate.iconType ? _menudelegate.iconType : ""
                                iconSize: _menudelegate.fontSize * 1.2
                                color: _menudelegate.textColor
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            DsLabel {
                                fontSize: _menudelegate.fontSize
                                color: _menudelegate.textColor
                                text: _menudelegate.text
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
