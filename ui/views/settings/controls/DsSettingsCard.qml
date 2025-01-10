import QtQuick
import QtQuick.Layouts
import app.digisto.modules

import "../../../controls"

Rectangle {
    width: root.width
    radius: Theme.btnRadius
    color: Theme.baseAlt1Color
    height: col.height + 2*Theme.xsSpacing

    property alias title: _title.text
    property alias desc: _desc.text
    property alias actions: actionrow.children
    default property alias cardContent: _contentcol.children

    Column {
        id: col
        width: parent.width - 2*Theme.xsSpacing
        spacing: Theme.xsSpacing
        anchors.centerIn: parent

        // Header
        RowLayout {
            width: col.width

            DsLabel {
                id: _title
                fontSize: Theme.xlFontSize
                color: Theme.txtPrimaryColor
                Layout.fillWidth: true
            }

            Row {
                id: actionrow
                spacing: Theme.xsSpacing
            }
        }

        DsLabel {
            id: _desc
            fontSize: Theme.xsFontSize
            color: Theme.txtHintColor
            bottomPadding: Theme.xsSpacing

            Rectangle {
                height: 1
                width: col.width
                color: Theme.baseAlt3Color
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Theme.xsSpacing/2
            }
        }
        // Header

        Column {
            id: _contentcol
            width: col.width
            spacing: col.spacing
        }
    }
}

