import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

import "../controls"
import "../popups"

DsPage {
    id: dashboardPage
    title: ""
    headerShown: false

    ColumnLayout {
        anchors.fill: parent
        spacing: Theme.smSpacing

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.lgBtnHeight
            Layout.leftMargin: Theme.baseSpacing
            Layout.rightMargin: Theme.baseSpacing
            Layout.topMargin: Theme.smSpacing
            spacing: Theme.smSpacing

            DsLabel {
                fontSize: Theme.h1
                color: Theme.txtHintColor
                text: qsTr("Inventory")
                Layout.alignment: Qt.AlignVCenter
            }

            DsLabel {
                fontSize: Theme.h1
                color: Theme.txtHintColor
                text: qsTr("/")
                Layout.alignment: Qt.AlignVCenter
            }

            DsLabel {
                fontSize: Theme.h2
                color: Theme.txtPrimaryColor
                text: qsTr("Products")
                Layout.alignment: Qt.AlignVCenter
            }

            DsIconButton {
                iconType: IconType.reload
                textColor: Theme.txtPrimaryColor
                bgColor: "transparent"
                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                radius: height/2
                Layout.alignment: Qt.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
                height: 1
            }

            DsButton {
                iconType: IconType.tablePlus
                text: qsTr("New Product")
                onClicked: newproductpopup.open()
            }
        }

        DsSearchInput {
            id: dsSearchInput
            placeHolderText: qsTr("What are you looking for?")
            Layout.preferredHeight: Theme.lgBtnHeight
            Layout.fillWidth: true
            Layout.leftMargin: Theme.baseSpacing
            Layout.rightMargin: Theme.baseSpacing
        }

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



    // Components
    DsNewProductPopup {
        id: newproductpopup
    }
}
