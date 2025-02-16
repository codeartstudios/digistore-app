import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import app.digisto.modules

Item {
    id: root
    title: qsTr("Organization Settings")

    // Label & Icon, to be shown on the settings navigation Page
    required property string title
    //required property string icon

    default property alias contentItem: col.data
    property alias spacing: col.spacing
    property real columnHorizontalMargin: 0 // X-Axis margin (left and right independently)

    // Paddings
    property alias leftPadding: col.leftPadding
    property alias rightPadding: col.rightPadding
    property alias topPadding: col.topPadding
    property alias bottomPadding: col.bottomPadding

    ScrollView {
        id: scrollview
        anchors.fill: parent

        // RowLayout causes width issues
        Row{
            spacing: 0
            width: parent.width

            Item {
                width: root.columnHorizontalMargin
                height: 1
            }

            Column {
                id: col
                width: root.width - 2*root.columnHorizontalMargin
                spacing: Theme.xsSpacing
            }

            Item {
                width: root.columnHorizontalMargin
                height: 1
            }
        }
    }
}
