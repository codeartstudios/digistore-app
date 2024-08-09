import QtQuick

import "../controls"

/*
  TellerPage
*/

DsPage {
    id: loginPage
    title: qsTr("Teller Page")

    Item {
        width: 400
        height: col.height + 2*theme.baseSpacing
        anchors.centerIn: parent

        Column {
            id: col
            width: parent.width - 2*theme.baseSpacing
            spacing: theme.xsSpacing
            anchors.centerIn: parent
        }
    }
}
