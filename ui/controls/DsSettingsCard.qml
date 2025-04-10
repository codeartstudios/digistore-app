import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import app.digisto.modules

Rectangle {
    id: bgrect
    radius: Theme.btnRadius
    color: Theme.baseColor
    height: col.height + 2*Theme.xsSpacing
    border.width: 1
    border.color: Theme.shadowColor

    property alias title: _title.text
    property alias desc: _desc.text
    property alias actions: actionrow.children
    default property alias cardContent: _contentcol.children

    Column {
        id: col
        width: bgrect.width - 2*Theme.xsSpacing
        spacing: Theme.xsSpacing
        anchors.centerIn: parent

        // Header
        Item {
            width: col.width
            height: hcol.height

            Column {
                id: hcol
                spacing: Theme.btnRadius
                anchors.left: parent.left
                anchors.right: actionrow.left

                DsLabel {
                    id: _title
                    width: parent.width
                    fontSize: Theme.xlFontSize
                    color: Theme.txtPrimaryColor
                }

                DsLabel {
                    id: _desc
                    fontSize: Theme.xsFontSize
                    color: Theme.txtHintColor
                    bottomPadding: Theme.xsSpacing
                }
            }

            Row {
                id: actionrow
                spacing: Theme.xsSpacing
                anchors.right: parent.right
                anchors.top: parent.top
            }

            Rectangle {
                height: 1
                width: parent.width
                color: Theme.baseAlt3Color
                anchors.bottom: parent.bottom
            }
        } // Header

        Column {
            id: _contentcol
            width: col.width
            spacing: col.spacing
        }
    }
}
