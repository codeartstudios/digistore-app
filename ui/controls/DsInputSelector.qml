import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import app.digisto.modules

import "../popups"

Rectangle {
    id: control
    radius: Theme.btnRadius
    implicitWidth: 200
    height: col.height + Theme.xsSpacing
    color: Theme.baseAlt1Color

    property string label: qsTr("Input")
    property bool mandatory: false

    // Flag to control selection criteria [single/multiple]
    property bool allowMultipleSelection: true

    // Alias to the value input control
    property alias input: input
    property alias placeHolderText: input.placeholderText
    property alias hintText: hintlabel.text

    // Model to hold value result data & selected data
    property var dataModel: []

    // Fields to be extracted from the model response for display
    property var displayFields: []

    // Popup height
    property alias popupHeight: popup.height

    // Control MouseArea control
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if(!control.enabled) return

            // Popup autocloses when we click outside of
            // it, this MouseArea reopens it, lets have a
            // 1s delay before allowing reopening
            if(!popup.closeDelayElapsed) return;

            // Close value popup if already opened
            if(popup.opened) popup.close()

            // Open popup and force active focus on the value input
            else {
                popup.open();
                input.forceActiveFocus()
            }
        }
    }

    // Layout for the control
    Column {
        id: col
        spacing: Theme.btnRadius
        width: parent.width - 2*Theme.xsSpacing
        anchors.centerIn: parent

        DsLabel {
            text: label
            color: Theme.txtPrimaryColor
            fontSize: Theme.xsFontSize

            DsLabel {
                text: "*"
                isBold: true
                visible: mandatory
                color: Theme.dangerColor
                fontSize: Theme.lgFontSize
                baselineOffset: parent.height
                anchors.baseline: parent.baseline
                anchors.left: parent.right
                anchors.leftMargin: 1
            }
        }

        Flow {
            id: flow
            width: parent.width
            spacing: Theme.xsSpacing

            // Show as placeholder
            DsLabel {
                id: hintlabel
                height: Theme.xsBtnHeight + 2*Theme.btnRadius
                visible: !control.dataModel || control.dataModel.length===0
                text: qsTr("Nothing selected yet!")
                font.pixelSize: Theme.smFontSize
                color: Theme.txtHintColor
                verticalAlignment: DsLabel.AlignVCenter
            }

            Repeater {
                model: control.dataModel
                delegate: Rectangle {
                    color: Theme.baseAlt2Color
                    radius: Theme.btnRadius
                    width: _drow.width
                    height: _drow.height

                    Row {
                        id: _drow
                        spacing: Theme.btnRadius
                        padding: Theme.btnRadius

                        // Label for the selected item
                        DsLabel {
                            text: modelData
                            font.pixelSize: Theme.smFontSize
                            color: Theme.txtPrimaryColor
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        // Remove item from model
                        DsIconButton {
                            height: Theme.xsBtnHeight
                            width: height
                            enabled: control.enabled
                            radius: Theme.btnRadius
                            textColor: Theme.dangerColor
                            bgColor: Theme.dangerAltColor
                            bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                            bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                            iconSize: Theme.smFontSize
                            iconType: IconType.x
                            anchors.verticalCenter: parent.verticalCenter

                            onClicked: {
                                if(!control.enabled) return

                                if(control.allowMultipleSelection) {
                                    var data = []
                                    for(var i=0; i<control.dataModel.length; i++) {
                                        if(i===index) continue
                                        data.push(control.dataModel[i])
                                    }
                                    control.dataModel = data
                                } else {
                                    control.dataModel=[]
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    DsPopup {
        id: popup
        width: control.width
        height: Theme.btnHeight + Theme.xsSpacing
        x: 0
        y: control.height - Theme.btnRadius
        borderWidth: 1
        borderColor: Theme.baseAlt1Color

        onClosed: {
            input.clear()
        }

        contentItem: Item {
            anchors.fill: parent

            RowLayout {
                spacing: Theme.xsSpacing/2
                width: parent.width - Theme.xsSpacing
                height: Theme.btnHeight
                anchors.centerIn: parent

                TextField {
                    id: input
                    padding: 0
                    width: parent.width - Theme.xsSpacing
                    height: Theme.inputHeight
                    color: Theme.txtPrimaryColor
                    placeholderTextColor: Theme.txtDisabledColor
                    font.pixelSize: Theme.xlFontSize
                    echoMode: TextField.Normal
                    background: Item {}
                    onAccepted: {
                        if(input.text.trim() !== "") {
                            if(!control.allowMultipleSelection)
                                control.dataModel = []

                            var dt = control.dataModel ? [...control.dataModel] : []
                            dt.push(input.text.trim())
                            control.dataModel = dt
                        }

                        input.clear()
                        if(!control.allowMultipleSelection) popup.close()
                    }


                    Layout.fillWidth: true
                    Layout.rightMargin: Theme.xsSpacing
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
    }

    DsMessageBox {
        id: messageBox
        z: parent.z
        x: (control.width-width)/2
        y: (control.height-height)/2

        function showMessage(_title, _info) {
            messageBox.title = _title
            messageBox.info = _info
            messageBox.open()
        }
    }
}
