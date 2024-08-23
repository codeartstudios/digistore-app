import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../controls"

DsPage {
    id: dashboardPage
    title: qsTr("Inventory Page")
    headerShown: true

    ListModel {
        id: headermodel

        ListElement {
            title: qsTr("#")
            sortable: false
            width: 70
            flex: 0
        }

        ListElement {
            title: qsTr("Product Name")
            sortable: true
            width: 300
            flex: 2
        }

        ListElement {
            title: qsTr("Buying Price")
            sortable: true
            width: 200
            flex: 1
        }

        ListElement {
            title: qsTr("Selling Price")
            sortable: true
            width: 200
            flex: 1
        }

        ListElement {
            title: qsTr("Stock")
            sortable: true
            width: 200
            flex: 1
        }
    }

    ColumnLayout {
        anchors.fill: parent

        DsTable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            headerModel: headermodel
            dataModel: headermodel
        }
    }
}
