import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import app.digisto.modules

Button {
    id: control
    implicitHeight: Theme.btnHeight
    implicitWidth: 300
    height: implicitHeight
    width: implicitWidth
    hoverEnabled: true
    text: model[lv.currentIndex]

    onClicked: popup.opened ? popup.close() : popup.open()

    property real fontSize: Theme.baseFontSize
    property real radius: bg.radius
    property real borderWidth: 1
    property string borderColor: Theme.txtPrimaryColor
    property string textColor: Theme.txtPrimaryColor
    property string bgColor: "transparent"
    property string bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
    property string bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

    // Model for the dropdown options
    property alias model: lv.model

    // Index of current selected item
    property alias currentIndex: lv.currentIndex

    background: Rectangle {
        id: bg
        color: control.enabled ? (down ? bgDown : hovered ? bgHover : bgColor) : bgColor
        radius: Theme.btnRadius
        opacity: control.enabled ? 1 : 0.4
        border.color: borderColor
        border.width: borderWidth
    }

    contentItem: Item {
        RowLayout {
            id: row
            spacing: Theme.xsSpacing
            anchors.fill: parent

            DsLabel {
                fontSize: control.fontSize
                color: control.textColor
                text: control.text
                horizontalAlignment: DsLabel.AlignLeft
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            DsIcon {
                id: endicon
                iconType: IconType.caretDown
                iconSize: control.fontSize * 1.2
                color: control.textColor
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }

    // Dropdown Popup to select/set an active item
    Popup {
        id: popup
        width: parent.width
        height: lv.height + 2*padding
        x: 0
        y: parent.height

        background: Rectangle {
            radius: Theme.xsSpacing
            color: Theme.bodyColor
            border.width: 1
            border.color: Theme.baseAlt1Color
        }

        contentItem: Item {
            ListView {
                id: lv
                currentIndex: 0
                width: parent.width
                height: (lv.modelSize) * Theme.btnHeight

                property int modelSize: isNaN(lv.model.count) ? lv.model.length : lv.model.count

                onModelChanged: currentIndex = currentIndex > modelSize-1 ? 0 : currentIndex

                delegate: DsButton {
                    id: btndelegate
                    height: Theme.btnHeight
                    width: lv.width
                    text: modelData
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                    contentItem: RowLayout {
                        DsLabel {
                            fontSize: btndelegate.fontSize
                            color: btndelegate.textColor
                            text: btndelegate.text
                            width: parent.width
                            Layout.alignment: Qt.AlignVCenter
                            Layout.fillWidth: true
                        }

                        DsIcon {
                            visible: lv.currentIndex===index
                            iconType: IconType.circleCheck
                            iconSize: control.fontSize * 1.2
                            color: control.textColor
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    onClicked: {
                        lv.currentIndex = index
                        popup.close()
                    }
                }
            }
        }
    }
}
