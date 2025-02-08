// DsSettingsRowTextInput Component
// Displays a `Text` element and a `TextInput` component
// side by side in a 'RowLayout'


import QtQuick
import QtQuick.Layouts
import app.digisto.modules

RowLayout {
    id: root
    width: parent.width
    spacing: Theme.xsSpacing

    property alias label: lbl.text
    property alias inputBox: input
    property alias text: input.text
    property alias validator: input.validator
    property alias placeholderText: input.placeholderText

    DsLabel {
        id: lbl
        fontSize: Theme.baseFontSize
        color: Theme.txtPrimaryColor
        Layout.alignment: Qt.AlignVCenter
        Layout.fillWidth: true
    }

    DsInputWithLabel {
        id: input
        labelShown: false
        color: Theme.bodyColor
        Layout.minimumWidth: 300
    }
}
