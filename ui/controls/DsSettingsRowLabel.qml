import QtQuick
import QtQuick.Layouts
import app.digisto.modules

RowLayout {
    width: parent.width
    spacing: Theme.xsSpacing

    property alias label: lbl.text
    property alias value: val.text

    DsLabel {
        id: lbl
        fontSize: Theme.baseFontSize
        color: Theme.txtPrimaryColor
        Layout.alignment: Qt.AlignVCenter
        Layout.fillWidth: true
    }

    DsLabel {
        id: val
        fontSize: Theme.baseFontSize
        color: Theme.txtHintColor
        height: Theme.inputHeight
        verticalAlignment: DsLabel.AlignVCenter
        horizontalAlignment: DsLabel.AlignRight
        Layout.alignment: Qt.AlignVCenter
        Layout.minimumWidth: 300
    }
}
