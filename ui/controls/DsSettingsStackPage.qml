import QtQuick
import QtQuick.Controls.Basic
import app.digisto.modules

Item {
    id: root
    title: qsTr("Organization Settings")

    // Label & Icon, to be shown on the settings navigation Page
    required property string title
    //required property string icon

    default property alias contentItem: col.children
    property alias spacing: col.spacing

    // Paddings
    property alias leftPadding: col.leftPadding
    property alias rightPadding: col.rightPadding
    property alias topPadding: col.topPadding
    property alias bottomPadding: col.bottomPadding

    ScrollView {
        id: scrollview
        anchors.fill: parent

        Column {
            id: col
            width: root.width
            spacing: Theme.xsSpacing
        }
    }
}
