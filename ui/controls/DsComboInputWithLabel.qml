// DsComboInputWithLabel Control
// Displays `TextInput` control with a label
// on top of it. The label can be used to show
// purpose of the text input below it.
// Additionally has secondary clickable text
// for any action needed.

import QtQuick.Controls.Basic
import QtQuick
import QtQuick.Layouts
import app.digisto.modules

Rectangle {
    id: control
    radius: Theme.btnRadius
    implicitWidth: 200
    implicitHeight: col.height + Theme.xsSpacing
    color: Theme.baseAlt1Color
    border.width: borderShown ? borderWidth : 0
    border.color: input.activeFocus ? borderFocusedColor: borderColor

    // Border properties ...
    property bool borderShown: true
    property real borderWidth: 1
    property string borderColor: Theme.shadowColor
    property string borderFocusedColor: Theme.primaryColor

    // Add a little animation to border changes ...
    Behavior on border.color { ColorAnimation { easing.type: Easing.InOutQuad }}
    Behavior on border.width { NumberAnimation { easing.type: Easing.InOutQuad }}

    // Text shows on top of the input component
    property string label: qsTr("Input")

    // TextInput Alias & placeholder text
    property alias placeholderText: input.placeholderText

    // Expose the text input validator property
    property alias validator: input.validator

    // Input errors, flag and text
    property bool hasError: false
    property string errorString: ""

    property bool mandatory: false

    // Secondary action label, shown beside the label
    property alias secondaryActionLabel: secondaryActionLabel

    // Toggle the label & secondary action label visibility
    property alias labelShown: labelrowly.visible
    property alias model: listview.model
    property alias currentIndex: listview.currentIndex

    // Before & After items
    property alias before: before
    property alias beforeItem: before.children
    property alias afterItem: after.children
    property alias after: after
    property alias inputRL: inputrow

    signal clicked()            // The root control was clicked
    signal textAccepted()       // Text was accepted on the TextInput
    signal secondaryAction()    // Secondary action was clicked

    // Convenience function to show/hide the error popup
    // on the text input
    function showError() { tt.show(errorString) }
    function closeError() { tt.close() }
    onHasErrorChanged: hasError ? showError() : closeError()

    Column {
        id: col
        spacing: Theme.xsSpacing/2
        width: parent.width - 2*Theme.xsSpacing
        anchors.centerIn: parent

        RowLayout {
            id: labelrowly
            width: parent.width
            spacing: Theme.xsSpacing

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

            Item {
                Layout.fillWidth: true
                height: 1
            }

            DsLabel {
                id: secondaryActionLabel
                visible: text !== "" && input.text.trim() !== ""
                color: Theme.txtPrimaryColor
                fontSize: Theme.xsFontSize

                MouseArea {
                    anchors.fill: parent
                    onClicked: if(control.enabled) control.secondaryAction()
                }
            }
        }

        RowLayout {
            id: inputrow
            width: parent.width
            spacing: Theme.btnRadius

            Row {
                id: before
                height: input.height
                Layout.alignment: Qt.AlignVCenter
            }

            DsTextField {
                id: input
                padding: 0
                height: Theme.inputHeight
                color: Theme.txtPrimaryColor
                placeholderTextColor: Theme.txtDisabledColor
                font.pixelSize: Theme.lgFontSize
                echoMode: TextField.Normal
                background: Item{}
                readOnly: true
                Layout.fillWidth: true
            }

            Row {
                id: after
                height: input.height
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }

    // MouseArea placed after the items to capture all items
    MouseArea {
        anchors.fill: parent
        onClicked: {
            // Propagate the clicked signal only when
            // the control is enabled
            if(control.enabled) {
                popup.open()
            }
        }
    }

    Popup {
        id: popup
        y: control.height - 1
        width: control.width
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

                bgColor: control.highlightedIndex === index ?
                             Theme.baseAlt1Color : "transparent"
                bgHover: control.highlightedIndex === index ?
                             Qt.lighter(Theme.baseAlt1Color, 0.8) : Qt.lighter(Theme.baseAlt1Color, 0.6)
                bgDown: bgHover
                textColor: Theme.txtPrimaryColor
                width: control.width
                fontSize: Theme.smFontSize
                text: model.label

                onClicked: {
                    listview.currentIndex = index
                    input.text = model.label
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
        input.text = ''
        listview.currentIndex = -1
    }
}
