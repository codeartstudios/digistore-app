import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Basic as QQCB
import app.digisto.modules

Item {
    id: root
    implicitHeight: 70
    implicitWidth: 500

    property alias placeHolderText: input.placeholderText

    Rectangle {
        id: rec
        color: Theme.baseAlt1Color
        radius: Theme.btnRadius
        anchors.fill: parent

        RowLayout {
            spacing: Theme.xsSpacing/2
            anchors.fill: parent

            DsIcon {
                iconSize: input.font.pixelSize
                iconType: IconType.search
                Layout.leftMargin: Theme.xsSpacing
                Layout.alignment: Qt.AlignVCenter
            }

            QQCB.TextField {
                id: input
                padding: 0
                width: parent.width - Theme.xsSpacing
                height: Theme.inputHeight
                color: Theme.txtPrimaryColor
                placeholderTextColor: Theme.txtDisabledColor
                font.pixelSize: Theme.xlFontSize
                echoMode: TextField.Normal
                background: Item {}

                Layout.fillWidth: true
                Layout.rightMargin: Theme.xsSpacing

                // Connect signal
                onTextChanged: {
                    if(text.length===0) {
                        searchPopup.close()
                    } else {
                        if(!searchPopup.opened)
                            searchPopup.open()
                    }
                }
            }

            DsIconButton {
                radius: height/2
                visible: input.text !== ""
                iconSize: input.font.pixelSize
                iconType: IconType.x
                Layout.rightMargin: Theme.xsSpacing
                Layout.alignment: Qt.AlignVCenter

                onClicked: input.clear()
            }
        }
    }

    Popup {
        id: searchPopup
        width: root.width
        height: 300
        x: 0; y: rec.height
        closePolicy: Popup.CloseOnPressOutside

        background: Rectangle {
            color: Theme.baseAlt1Color
            radius: Theme.btnRadius

            Rectangle {
                height: Theme.btnRadius*1.5
                width: parent.width
                color: parent.color
                anchors.top: parent.top
                anchors.topMargin: -Theme.btnRadius*0.2
            }
        }

        contentItem: Item {
            anchors.fill: parent

            ListView {
                anchors.fill: parent
            }
        }
    }
}
