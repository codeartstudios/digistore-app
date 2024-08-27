import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Basic as QQCB
import app.digisto.modules

Item {
    id: root
    implicitHeight: 70
    implicitWidth: 500

    signal textChanged(var text)


    property alias busy: busyindicator.running
    property alias model: searchlvresults.model

    // Delay between typing before we make a request
    property int delay: 500
    property alias placeHolderText: input.placeholderText


    Timer {
        id: delaytimer
        repeat: false
        interval: delay
        onTriggered: root.textChanged(input.text.trim())
    }

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

                    if(delaytimer.running) delaytimer.restart()
                    else delaytimer.start()
                }
            }

            DsBusyIndicator {
                id: busyindicator
                visible: running
                duration: 600
            }

            DsIconButton {
                radius: height/2
                visible: input.text !== ""
                iconSize: input.font.pixelSize
                iconType: IconType.x
                textColor: Theme.txtPrimaryColor
                bgColor: "transparent"
                bgHover: Theme.dangerAltColor
                bgDown: withOpacity(Theme.dangerAltColor, 0.8)
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

        onOpened: {
            searchlvresults.currentIndex=-1
            searchlvresults.model.clear()
        }

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
                id: searchlvresults
                clip: true
                anchors.fill: parent
                anchors.bottomMargin: Theme.xsSpacing

                highlight: Rectangle {
                    color: Theme.dangerAltColor
                    height: 50
                    width: searchlvresults.width
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: Theme.baseAlt3Color
                    anchors.top: parent.top
                }

                delegate: Rectangle {
                    width: searchlvresults.width
                    height: 50
                    color: searchlvresults.currentIndex===index ? "transparent" : Theme.baseAlt1Color
                    opacity: delegatema.hovered ? 0.8 : 1

                    MouseArea {
                        id: delegatema
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: hovered=true
                        onExited: hovered=false
                        onClicked: searchlvresults.currentIndex=index
                        property bool hovered: false
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Theme.baseAlt3Color
                        anchors.bottom: parent.bottom
                    }

                    Item {
                        anchors.fill: parent
                        anchors.leftMargin: Theme.smSpacing
                        anchors.rightMargin: Theme.smSpacing

                        DsLabel {
                            text: model.name
                            fontSize: Theme.lgFontSize
                            elide: DsLabel.ElideRight
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                        }
                    }
                }
            }
        }
    }
}
