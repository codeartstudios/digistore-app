import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import app.digisto.modules

Rectangle {
    id: root
    width: scrollview.width
    height: Theme.btnHeight

    required property string label
    property string value: qsTr('<not set>')
    property bool hasPermissions: false

    property alias model: listview.model
    property alias currentIndex: listview.currentIndex

    onCurrentIndexChanged: {
        if(currentIndex < 0)
            value = qsTr('<not set>')
        else
            value = model[currentIndex].label
    }

    RowLayout {
        width: parent.width
        height: Theme.btnHeight
        spacing: Theme.xsSpacing/2

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Theme.xsSpacing
        anchors.rightMargin: Theme.xsSpacing
        anchors.verticalCenter: parent.verticalCenter

        DsLabel {
            color: Theme.txtPrimaryColor
            fontSize: Theme.xlFontSize
            text: root.label
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        Row {
            spacing: Theme.btnRadius
            Layout.alignment: Qt.AlignVCenter

            DsLabel {
                color: Theme.txtPrimaryColor
                fontSize: Theme.xlFontSize
                text: root.value
                anchors.verticalCenter: parent.verticalCenter
            }

            DsIcon {
                iconSize: Theme.baseFontSize
                iconType: IconType.chevronDown
                iconColor: Theme.txtHintColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    DsMouseArea {
        anchors.fill: parent
        onClicked: if(hasPermissions)
                       popup.opened ? popup.close() : popup.open()
    }

    Popup {
        id: popup
        x: parent.width - width - Theme.xsSpacing
        y: parent.height - 1
        width: 200
        implicitHeight: contentItem.implicitHeight
        padding: 1

        contentItem: ListView {
            id: listview
            clip: true
            implicitHeight: contentHeight
            currentIndex: -1

            ScrollIndicator.vertical: ScrollIndicator { }

            delegate: DsButton {
                id: btndlgt

                required property var model
                required property int index

                bgColor: parent.highlightedIndex === index ?
                             Theme.baseAlt1Color : "transparent"
                bgHover: parent.highlightedIndex === index ?
                             Qt.lighter(Theme.baseAlt1Color, 0.8) : Qt.lighter(Theme.baseAlt1Color, 0.6)
                bgDown: bgHover
                textColor: Theme.txtPrimaryColor
                width: parent.width
                fontSize: Theme.smFontSize
                text: model.label

                onClicked: {
                    listview.currentIndex = index
                    value = model.label
                    popup.close()
                }

                contentItem: Item {
                    DsLabel {
                        fontSize: btndlgt.fontSize
                        color: btndlgt.textColor
                        text: btndlgt.text
                        width: parent.width
                        elide: DsLabel.ElideRight
                        leftPadding: Theme.xsSpacing/2
                        rightPadding: Theme.xsSpacing/2
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: DsLabel.AlignLeft
                    }
                }
            }
        }

        background: Rectangle {
            radius: Theme.btnRadius
            color: Theme.bodyColor
            border.width: 1
            border.color: Theme.shadowColor
        }
    }

    // ------------------------------------- //
    // HELPER FUNCTIONS
    // ------------------------------------- //

    function clear() {
        value = ''
        listview.currentIndex = -1
    }
}

