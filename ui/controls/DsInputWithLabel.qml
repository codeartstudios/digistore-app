// DsInputWithLabel Control
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
    property alias input: input
    property alias placeholderText: input.placeholderText

    // Text alias to the input text
    property alias text: input.text

    // Toggle text input password visibility
    property bool isPasswordInput: false

    // Expose the text input validator property
    property alias validator: input.validator

    // Input errors, flag and text
    property bool hasError: false
    property string errorString: ""

    property bool mandatory: false
    property bool readOnly: false

    // Secondary action label, shown beside the label
    property alias secondaryActionLabel: secondaryActionLabel

    // Toggle the label & secondary action label visibility
    property alias labelShown: labelrowly.visible

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

    // MouseArea placed before items of the control are added, that way,
    // the mousearea does not take over all mouse actions making text input
    // impossible to do.
    MouseArea {
        anchors.fill: parent
        onClicked: {
            // Propagate the clicked signal only when
            // the control is enabled
            if(control.enabled) {
                input.forceActiveFocus();
                control.clicked()
            }
        }
    }

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

            TextField {
                id: input
                padding: 0
                height: Theme.inputHeight
                color: Theme.txtPrimaryColor
                placeholderTextColor: Theme.txtDisabledColor
                font.pixelSize: Theme.lgFontSize
                echoMode: isPasswordInput ? TextField.Password : TextField.Normal
                background: Item{}
                readOnly: control.readOnly
                Layout.fillWidth: true

                onAccepted: control.textAccepted()

                DsToolTip {
                    id: tt
                    text: errorString
                    delay: 0
                    width: parent.width
                    side: DsToolTip.Bottom
                    bgRect.color: Theme.warningColor
                    onClosed: hasError=false
                }
            }

            Row {
                id: after
                height: input.height
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }
}
