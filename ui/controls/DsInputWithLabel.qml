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

    property string label: qsTr("Input")
    property alias input: input
    property alias text: input.text
    property bool isPasswordInput: false
    property alias validator: input.validator
    property bool hasError: false
    property bool mandatory: false
    property string errorString: ""
    property bool readOnly: false
    property alias secondaryActionLabel: secondaryActionLabel
    property alias labelShown: labelrowly.visible

    // Before & After items
    property alias before: before
    property alias beforeItem: before.children
    property alias afterItem: after.children
    property alias after: after
    property alias inputRL: inputrow

    signal clicked()
    signal textAccepted()
    signal secondaryAction()

    function showError() { tt.show(errorString) }
    function closeError() { tt.close() }

    onHasErrorChanged: hasError ? showError() : closeError()

    MouseArea {
        anchors.fill: parent
        onClicked: {
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
