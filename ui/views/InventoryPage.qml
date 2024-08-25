import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../controls"

DsPage {
    id: dashboardPage
    title: qsTr("Inventory Page")
    headerShown: true

    ColumnLayout {
        anchors.fill: parent

        DsTable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            headerModel: headermodel
            dataModel: datamodel
        }
    }

    ListModel {
        id: datamodel

        Component.onCompleted: {
            datamodel.append([
                                 {
                                     id: "RECORD_ID",
                                     collectionId: "893lh3lly17guqa",
                                     collectionName: "product",
                                     created: "2022-01-01 01:00:00.123Z",
                                     updated: "2022-01-01 23:59:59.456Z",
                                     name: "Dairy Meal",
                                     unit: "50kg",
                                     barcode: "5678975679",
                                     buying_price: 1250,
                                     selling_price: 1500,
                                     stock: 10,
                                     thumbnail: "filename.jpg",
                                     organization: "RELATION_RECORD_ID"
                                 },
                                 {
                                     id: "RECORD_ID",
                                     collectionId: "893lh3lly17guqa",
                                     collectionName: "product",
                                     created: "2022-01-01 01:00:00.123Z",
                                     updated: "2022-01-01 23:59:59.456Z",
                                     name: "Chick Mash",
                                     unit: "1kg",
                                     barcode: "test",
                                     buying_price: 44,
                                     selling_price: 50,
                                     stock: 200,
                                     thumbnail: "filename.jpg",
                                     organization: "RELATION_RECORD_ID"
                                 },
                                 {
                                     id: "RECORD_ID",
                                     collectionId: "893lh3lly17guqa",
                                     collectionName: "product",
                                     created: "2022-01-01 01:00:00.123Z",
                                     updated: "2022-01-01 23:59:59.456Z",
                                     name: "Macklick Super",
                                     unit: "1kg",
                                     barcode: "test",
                                     buying_price: 130,
                                     selling_price: 150,
                                     stock: 30,
                                     thumbnail: "filename.jpg",
                                     organization: "RELATION_RECORD_ID"
                                 },
                                 {
                                     id: "RECORD_ID",
                                     collectionId: "893lh3lly17guqa",
                                     collectionName: "product",
                                     created: "2022-01-01 01:00:00.123Z",
                                     updated: "2022-01-01 23:59:59.456Z",
                                     name: "Macklick Super",
                                     unit: "2kg",
                                     barcode: "test",
                                     buying_price: 210,
                                     selling_price: 230,
                                     stock: 35,
                                     thumbnail: "filename.jpg",
                                     organization: "RELATION_RECORD_ID"
                                 },
                                 {
                                     id: "RECORD_ID",
                                     collectionId: "893lh3lly17guqa",
                                     collectionName: "product",
                                     created: "2022-01-01 01:00:00.123Z",
                                     updated: "2022-01-01 23:59:59.456Z",
                                     name: "Albendazole Tablets",
                                     unit: "1pc",
                                     barcode: "test",
                                     buying_price: 5,
                                     selling_price: 10,
                                     stock: 230,
                                     thumbnail: "filename.jpg",
                                     organization: "RELATION_RECORD_ID"
                                 },
                                 {
                                     id: "RECORD_ID",
                                     collectionId: "893lh3lly17guqa",
                                     collectionName: "product",
                                     created: "2022-01-01 01:00:00.123Z",
                                     updated: "2022-01-01 23:59:59.456Z",
                                     name: "Nilzan Bolus",
                                     unit: "1pc",
                                     barcode: "test",
                                     buying_price: 27,
                                     selling_price: 25,
                                     stock: 86,
                                     thumbnail: "filename.jpg",
                                     organization: "RELATION_RECORD_ID"
                                 },
                                 {
                                     id: "RECORD_ID",
                                     collectionId: "893lh3lly17guqa",
                                     collectionName: "product",
                                     created: "2022-01-01 01:00:00.123Z",
                                     updated: "2022-01-01 23:59:59.456Z",
                                     name: "Milking Salve",
                                     unit: "100g",
                                     barcode: "test",
                                     buying_price: 84,
                                     selling_price: 100,
                                     stock: 24,
                                     thumbnail: "filename.jpg",
                                     organization: "RELATION_RECORD_ID"
                                 }]
                             )
        }
    }

    ListModel {
        id: headermodel

        ListElement {
            title: qsTr("Product Name")
            sortable: true
            width: 300
            flex: 2
            value: "name"
        }

        ListElement {
            title: qsTr("Buying Price")
            sortable: true
            width: 200
            flex: 1
            value: "buying_price"
        }

        ListElement {
            title: qsTr("Selling Price")
            sortable: true
            width: 200
            flex: 1
            value: "selling_price"
        }

        ListElement {
            title: qsTr("Stock")
            sortable: true
            width: 200
            flex: 1
            value: "stock"
        }
    }
}
