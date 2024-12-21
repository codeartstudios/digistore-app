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

    signal clicked()
    signal inFullClicked()
    signal inputTextChanged(value: var)

    function showError() { tt.show(errorString) }
    function closeError() { tt.close() }

    onHasErrorChanged: hasError ? showError() : closeError()

    Column {
        id: col
        spacing: 0
        width: parent.width - 2 * Theme.xsSpacing
        anchors.centerIn: parent

        Item {
            height: 20
            width: parent.width

            DsLabel {
                text: label
                color: Theme.txtPrimaryColor
                fontSize: Theme.smFontSize
                anchors.verticalCenter: parent.verticalCenter
            }

            DsLabel {
                text: qsTr("In full")
                isUnderlined: true
                color: Theme.txtPrimaryColor
                fontSize: Theme.smFontSize
                height: parent.height
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    enabled: root.enabled
                    anchors.fill: parent
                    onClicked: root.inFullClicked()
                }
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

                onTextChanged: {
                    root.inputTextChanged(input.text)
                }

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
        onClicked: { input.forceActiveFocus(); root.clicked() }
    }
}
