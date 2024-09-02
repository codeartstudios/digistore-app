import QtQuick
import QtQuick.Layouts
import app.digisto.modules

Item {
    id: root
    implicitHeight: col.height
    height: implicitHeight
    width: parent.width

    property string label: ""
    property string value: ""

    Column {
        id: col
        spacing: Theme.btnRadius
        width: parent.width

        DsLabel {
            id: _label
            wrapMode: DsLabel.NoWrap
            elide: DsLabel.ElideRight
            width: parent.width
            text: root.label
            fontSize: Theme.baseFontSize
            color: Theme.txtHintColor
        }

        DsLabel {
            id: _value
            wrapMode: DsLabel.NoWrap
            elide: DsLabel.ElideRight
            width: parent.width
            text: root.value==="" ? qsTr("N/A") : root.value
            fontSize: Theme.lgFontSize
        }
    }
}
