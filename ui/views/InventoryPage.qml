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
                                     name: "test",
                                     unit: "test",
                                     barcode: "test",
                                     buying_price: 123,
                                     selling_price: 123,
                                     stock: 123,
                                     thumbnail: "filename.jpg",
                                     organization: "RELATION_RECORD_ID"
                                 },
                                 {
                                     id: "RECORD_ID",
                                     collectionId: "893lh3lly17guqa",
                                     collectionName: "product",
                                     created: "2022-01-01 01:00:00.123Z",
                                     updated: "2022-01-01 23:59:59.456Z",
                                     name: "test",
                                     unit: "test",
                                     barcode: "test",
                                     buying_price: 123,
                                     selling_price: 123,
                                     stock: 123,
                                     thumbnail: "filename.jpg",
                                     organization: "RELATION_RECORD_ID"
                                 },
                                 {
                                     id: "RECORD_ID",
                                     collectionId: "893lh3lly17guqa",
                                     collectionName: "product",
                                     created: "2022-01-01 01:00:00.123Z",
                                     updated: "2022-01-01 23:59:59.456Z",
                                     name: "test",
                                     unit: "test",
                                     barcode: "test",
                                     buying_price: 123,
                                     selling_price: 123,
                                     stock: 123,
                                     thumbnail: "filename.jpg",
                                     organization: "RELATION_RECORD_ID"
                                 },
                                 {
                                     id: "RECORD_ID",
                                     collectionId: "893lh3lly17guqa",
                                     collectionName: "product",
                                     created: "2022-01-01 01:00:00.123Z",
                                     updated: "2022-01-01 23:59:59.456Z",
                                     name: "test",
                                     unit: "test",
                                     barcode: "test",
                                     buying_price: 123,
                                     selling_price: 123,
                                     stock: 123,
                                     thumbnail: "filename.jpg",
                                     organization: "RELATION_RECORD_ID"
                                 },
                                 {
                                     id: "RECORD_ID",
                                     collectionId: "893lh3lly17guqa",
                                     collectionName: "product",
                                     created: "2022-01-01 01:00:00.123Z",
                                     updated: "2022-01-01 23:59:59.456Z",
                                     name: "test",
                                     unit: "test",
                                     barcode: "test",
                                     buying_price: 123,
                                     selling_price: 123,
                                     stock: 123,
                                     thumbnail: "filename.jpg",
                                     organization: "RELATION_RECORD_ID"
                                 },
                                 {
                                     id: "RECORD_ID",
                                     collectionId: "893lh3lly17guqa",
                                     collectionName: "product",
                                     created: "2022-01-01 01:00:00.123Z",
                                     updated: "2022-01-01 23:59:59.456Z",
                                     name: "test",
                                     unit: "test",
                                     barcode: "test",
                                     buying_price: 123,
                                     selling_price: 123,
                                     stock: 123,
                                     thumbnail: "filename.jpg",
                                     organization: "RELATION_RECORD_ID"
                                 },
                                 {
                                     id: "RECORD_ID",
                                     collectionId: "893lh3lly17guqa",
                                     collectionName: "product",
                                     created: "2022-01-01 01:00:00.123Z",
                                     updated: "2022-01-01 23:59:59.456Z",
                                     name: "test",
                                     unit: "test",
                                     barcode: "test",
                                     buying_price: 123,
                                     selling_price: 123,
                                     stock: 123,
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
}
