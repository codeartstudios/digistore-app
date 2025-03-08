import QtQuick
import QtQuick.Layouts
import app.digisto.modules

Rectangle {
    id: root
    width: scrollview.width
    height: Theme.btnHeight

    required property string label
    required property string value

    RowLayout {
        width: parent.width
        height: Theme.btnHeight
        spacing: Theme.xsSpacing/2

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Theme.xsSpacing
        anchors.rightMargin: Theme.xsSpacing
        anchors.verticalCenter: parent.verticalCenter

        DsLabel {
            color: Theme.txtPrimaryColor
            fontSize: Theme.xlFontSize
            text: root.label
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        DsLabel {
            color: Theme.txtPrimaryColor
            fontSize: Theme.xlFontSize
            text: root.value
            Layout.alignment: Qt.AlignVCenter
        }
    }
}

