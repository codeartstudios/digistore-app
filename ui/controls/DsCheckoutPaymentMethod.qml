import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import app.digisto.modules

Rectangle {
    id: root
    radius: Theme.btnRadius
    implicitWidth: 200
    height: col.height + Theme.xsSpacing
    color: Theme.baseAlt1Color
    border.width: input.activeFocus ? 1 : 0
    border.color: Theme.successColor

    property string label: qsTr("Input")
    property alias input: input
    property alias value: input.text
    property bool isPasswordInput: false
    property alias validator: input.validator
    property bool hasError: false
    property bool mandatory: false
    property bool showBusyIndicator: false
    property string errorString: ""
    property bool readOnly: false
    property bool forceInputActiveFocusOnClick: true

    signal clicked()
    signal removePayment()
    signal inputTextChanged(value: var)

    function showError() { tt.show(errorString) }
    function closeError() { tt.close() }

    onHasErrorChanged: hasError ? showError() : closeError()

    Column {
        id: col
        anchors.left: parent.left
        anchors.right: removeBtn.left
        anchors.leftMargin: Theme.xsSpacing
        anchors.rightMargin: Theme.xsSpacing
        anchors.verticalCenter: parent.verticalCenter

        Item {
            height: 20
            width: parent.width

            DsLabel {
                text: label
                color: Theme.txtPrimaryColor
                fontSize: Theme.smFontSize
                anchors.verticalCenter: parent.verticalCenter
            }

        }

        RowLayout {
            height: Theme.inputHeight
            width: parent.width

            TextField {
                id: input
                padding: 0
                color: Theme.txtPrimaryColor
                placeholderTextColor: Theme.txtDisabledColor
                font.pixelSize: Theme.lgFontSize
                echoMode: isPasswordInput ? TextField.Password : TextField.Normal
                background: Item{}
                readOnly: root.readOnly
                Layout.fillWidth: true
                Layout.fillHeight: true

                onTextChanged: root.inputTextChanged(input.text)

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

            DsBusyIndicator {
                running: showBusyIndicator
                visible: showBusyIndicator
                Layout.fillHeight: true
                Layout.preferredWidth: Theme.inputHeight
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if(root.forceInputActiveFocusOnClick)
                input.forceActiveFocus();
            root.clicked()
        }
    }

    DsIconButton {
        id: removeBtn
        iconType: IconType.x
        textColor: Theme.txtPrimaryColor
        bgColor: "transparent"
        bgHover: withOpacity(Theme.dangerAltColor, 0.8)
        bgDown: withOpacity(Theme.dangerAltColor, 0.6)
        radius: height/2

        anchors.right: parent.right
        anchors.rightMargin: Theme.xsSpacing
        anchors.verticalCenter: parent.verticalCenter

        onClicked: root.removePayment()
    }
}
