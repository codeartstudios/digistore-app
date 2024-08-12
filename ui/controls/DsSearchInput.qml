import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Basic as QQCB

Item {
    id: root
    implicitHeight: 70
    implicitWidth: 500

    property alias placeHolderText: input.placeholderText

    Rectangle {
        id: rec
        color: theme.baseAlt1Color
        radius: theme.btnRadius
        anchors.fill: parent

        RowLayout {
            spacing: theme.xsSpacing/2
            anchors.fill: parent

            DsIcon {
                iconSize: input.font.pixelSize
                iconType: dsIconType.search
                Layout.leftMargin: theme.xsSpacing
                Layout.alignment: Qt.AlignVCenter
            }

            QQCB.TextField {
                id: input
                padding: 0
                width: parent.width - theme.xsSpacing
                height: theme.inputHeight
                color: theme.txtPrimaryColor
                placeholderTextColor: theme.txtDisabledColor
                font.pixelSize: theme.xlFontSize
                echoMode: TextField.Normal
                background: Item {}

                Layout.fillWidth: true
                Layout.rightMargin: theme.xsSpacing

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
        }
    }

    Popup {
        id: searchPopup
        width: root.width
        height: 300
        x: 0; y: rec.height
        closePolicy: Popup.CloseOnPressOutside

        background: Rectangle {
            color: theme.baseAlt1Color
            radius: theme.btnRadius

            Rectangle {
                height: theme.btnRadius*1.5
                width: parent.width
                color: parent.color
                anchors.top: parent.top
                anchors.topMargin: -theme.btnRadius*0.2
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
