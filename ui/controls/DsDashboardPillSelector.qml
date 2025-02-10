import QtQuick
import QtQuick.Controls.Basic
import app.digisto.modules

Item {
    id: root
    width: row.width + Theme.xsSpacing
    height: row.height + Theme.xsSpacing

    property bool hovered: false
    property int currentIndex: 0
    required property var model

    Row {
        id: row
        spacing: Theme.btnRadius
        anchors.centerIn: parent

        DsLabel {
            id: periodSelector
            fontSize: Theme.smFontSize
            text: root.model[root.currentIndex]
            color: Theme.txtPrimaryColor
            isUnderlined: root.hovered || popup.opened
            anchors.verticalCenter: parent.verticalCenter
        }

        DsIcon {
            iconSize: Theme.baseFontSize
            iconColor: Theme.txtPrimaryColor
            iconType: IconType.chevronDown
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // DropDown popup to allow data selection
    // populated from the model provided
    DsPopup {
        id: popup
        y: parent.height * 0.95     // Position toward the bottom of the parent
        x: parent.width - width - Theme.xsSpacing/2 // Right edge be some space
        padding: Theme.btnRadius
        implicitWidth: 150
        implicitHeight: root.model.length * Theme.smBtnHeight + 2*padding
        borderWidth: 1; borderColor: Theme.shadowColor

        contentItem: ListView {
            id: lv
            clip: true
            implicitHeight: contentHeight
            model: root.model
            currentIndex: root.currentIndex
            onCurrentIndexChanged: root.currentIndex=currentIndex

            // Show scrollbars where necessary
            ScrollIndicator.vertical: ScrollIndicator { }

            delegate: DsButton {
                id: popupdelegate
                text: modelData
                width: lv.width
                height: Theme.smBtnHeight
                bgColor: 'transparent'
                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                textColor: selected ? Theme.infoColor : Theme.txtPrimaryColor

                // delegate is selected if its `index` equals ListView's `currentIndex`
                property bool selected: index===lv.currentIndex

                // Set current index then close the popup
                onClicked: {
                    lv.currentIndex = index
                    popup.close()
                }

                // Override the content item with a label
                contentItem: DsLabel {
                    fontSize: Theme.smFontSize
                    text: popupdelegate.text
                    color: popupdelegate.textColor
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: parent.hovered = true
        onExited: parent.hovered = false
        onClicked: popup.open()
    }
}

