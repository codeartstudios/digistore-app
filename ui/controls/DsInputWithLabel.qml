import QtQuick.Controls.Basic
import QtQuick

Rectangle {
    id: control
    radius: theme.btnRadius
    implicitWidth: 200
    height: col.height + theme.xsSpacing
    color: theme.baseAlt1Color

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
        width: parent.width - 2*theme.xsSpacing
        anchors.centerIn: parent

        DsLabel {
            text: label
            color: theme.txtPrimaryColor
            fontSize: theme.xsFontSize
        }

        TextField {
            id: input
            padding: 0
            height: theme.inputHeight
            width: parent.width
            color: theme.txtPrimaryColor
            placeholderTextColor: theme.txtDisabledColor
            font.pixelSize: theme.lgFontSize
            echoMode: isPasswordInput ? TextField.Password : TextField.Normal
            background: Item{}

            DsToolTip {
                id: tt
                text: errorString
                delay: 0
                width: parent.width
                side: DsToolTip.Bottom
                bgRect.color: theme.warningColor
                onClosed: hasError=false
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: input.forceActiveFocus()
    }
}
