import QtQuick
import QtQuick.Layouts

Item {
    id: root
    height: col.height
    width: parent.width

    property string label: ""
    property string value: ""

    Column {
        id: col
        spacing: theme.btnRadius
        width: parent.width

        DsLabel {
            id: _label
            wrapMode: DsLabel.NoWrap
            elide: DsLabel.ElideRight
            width: parent.width
            text: root.label
            fontSize: theme.xlFontSize
        }

        DsLabel {
            id: _value
            wrapMode: DsLabel.NoWrap
            elide: DsLabel.ElideRight
            width: parent.width
            text: root.value
            fontSize: theme.smFontSize
        }
    }
}
