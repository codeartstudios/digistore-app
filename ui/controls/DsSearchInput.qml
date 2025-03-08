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
    signal accepted(var object)

    property bool searchEnabled: false

    property alias busy: busyindicator.running
    property alias model: searchlvresults.model

    // Delay between typing before we make a request
    property int delay: 500
    property alias placeHolderText: input.placeholderText

    // Forward the UP/DOWN key press to navigate the listview
    Keys.onDownPressed: {
        if(searchlvresults.currentIndex >= searchlvresults.model.count-1 )
            searchlvresults.currentIndex=0
        else
            searchlvresults.currentIndex+=1
    }

    Keys.onUpPressed: {
        if(searchlvresults.currentIndex <= 0 )
            searchlvresults.currentIndex=searchlvresults.model.count-1
        else
            searchlvresults.currentIndex-=1
    }

    MouseArea {
        anchors.fill: parent
        onClicked: if(searchEnabled) input.forceActiveFocus()
    }

    Timer {
        id: delaytimer
        repeat: false
        interval: delay
        onTriggered: if(input.text.trim()!=="") root.textChanged(input.text.trim())
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
                readOnly: !searchEnabled
                background: Item {}
                onAccepted: searchlvresults.accepted()

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
                Layout.alignment: Qt.AlignVCenter
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
        x: 0
        y: rec.height
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
                model: ListModel{}
                keyNavigationEnabled: true
                keyNavigationWraps: true
                anchors.fill: parent
                anchors.bottomMargin: Theme.xsSpacing
                ScrollBar.vertical: ScrollBar{}

                signal accepted()

                onModelChanged: {
                    if(model.count > 0) {
                        if(currentIndex<=0)
                            currentIndex=0
                        else if(currentIndex>searchlvresults.model.count-1)
                            currentIndex=searchlvresults.model.count-1
                    } else {
                        currentIndex=-1
                    }
                }

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
                        property bool hovered: false

                        hoverEnabled: true
                        onEntered: hovered=true
                        onExited: hovered=false
                        anchors.fill: parent

                        onClicked: {
                            searchlvresults.currentIndex=index
                            root.accepted(model)
                            input.clear()
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Theme.baseAlt3Color
                        anchors.bottom: parent.bottom
                    }

                    Item {
                        anchors.fill: parent
                        anchors.leftMargin: Theme.xsSpacing*2 + input.font.pixelSize
                        anchors.rightMargin: Theme.xsSpacing*2 + input.font.pixelSize

                        DsLabel {
                            text: model.fullname
                            fontSize: Theme.lgFontSize
                            elide: DsLabel.ElideRight
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: pricelbl.left
                        }

                        DsLabel {
                            id: pricelbl
                            text: `${orgCurrency.symbol} ${model.selling_price}`
                            fontSize: Theme.lgFontSize
                            elide: DsLabel.ElideRight
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                        }
                    }

                    Connections {
                        target: input

                        function onAccepted() {
                            if(searchlvresults.currentIndex===index) {
                                root.accepted(model)
                                input.clear()
                            }
                        }
                    }
                }
            }
        }
    }
}
