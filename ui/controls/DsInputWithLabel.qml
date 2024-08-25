import QtQuick.Controls.Basic
import QtQuick

Rectangle {
    id: control
    radius: Theme.btnRadius
    implicitWidth: 200
    height: col.height + Theme.xsSpacing
    color: Theme.baseAlt1Color

    property string label: qsTr("Input")
    property alias input: input
    property bool isPasswordInput: false
    property alias validator: input.validator
    property bool hasError: false
    property string errorString: ""

    function showError() { tt.show(errorString) }
    function closeError() { tt.close() }

    onHasErrorChanged: hasError ? showError() : closeError()

    Column {
        id: col
        spacing: 0
        width: parent.width - 2*Theme.xsSpacing
        anchors.centerIn: parent

        DsLabel {
            text: label
            color: Theme.txtPrimaryColor
            fontSize: Theme.xsFontSize
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

    MouseArea {
        anchors.fill: parent
        onClicked: input.forceActiveFocus()
    }
}
