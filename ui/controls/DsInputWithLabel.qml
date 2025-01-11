import QtQuick.Controls.Basic
import QtQuick
import QtQuick.Layouts
import app.digisto.modules

Rectangle {
    id: control
    radius: Theme.btnRadius
    implicitWidth: 200
    height: col.height + Theme.xsSpacing
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
        spacing: 0
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
                visible: text !== ""
                color: Theme.txtPrimaryColor
                fontSize: Theme.xsFontSize

                MouseArea {
                    anchors.fill: parent
                    onClicked: if(control.enabled) control.secondaryAction()
                }
            }
        }

        TextField {
            id: input
            padding: 0
            height: Theme.inputHeight
            width: parent.width
            color: Theme.txtPrimaryColor
            placeholderTextColor: Theme.txtDisabledColor
            font.pixelSize: Theme.lgFontSize
            echoMode: isPasswordInput ? TextField.Password : TextField.Normal
            background: Item{}
            readOnly: control.readOnly

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
    }
}
