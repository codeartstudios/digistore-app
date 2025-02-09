// DsSettingsRowTextInput Component
// Displays two `Text` elements
// side by side in a 'RowLayout'
// for displaying label and value kind of

import QtQuick
import QtQuick.Layouts
import app.digisto.modules

RowLayout {
    id: root
    width: parent.width
    spacing: Theme.xsSpacing

    property alias label: lbl.text
    property string value

    DsLabel {
        id: lbl
        fontSize: Theme.baseFontSize
        color: Theme.txtPrimaryColor
        Layout.alignment: Qt.AlignVCenter
        Layout.fillWidth: true
    }

    DsLabel {
        id: val
        text: (!root.value || root.value === "") ?
                  qsTr("N/A") : root.value
        fontSize: Theme.baseFontSize
        color: Theme.txtHintColor
        height: Theme.inputHeight
        verticalAlignment: DsLabel.AlignVCenter
        horizontalAlignment: DsLabel.AlignRight
        Layout.alignment: Qt.AlignVCenter
        Layout.minimumWidth: 300
    }
}
