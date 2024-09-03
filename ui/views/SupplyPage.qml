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

    property real pageNo: 1
    property real totalPages: 0
    property real totalItems: 0
    property real itemsPerPage: 100

    property string sortByKey: "name"
    property bool sortAsc: true

    property ListModel datamodel: ListModel{}

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
                text: qsTr("Supply")
                Layout.alignment: Qt.AlignVCenter
            }

            DsIconButton {
                enabled: !getSupplyRequest.running
                iconType: IconType.reload
                textColor: Theme.txtPrimaryColor
                bgColor: "transparent"
                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                radius: height/2
                Layout.alignment: Qt.AlignVCenter

                onClicked: getInventorySupply()
            }

            Item {
                Layout.fillWidth: true
                height: 1
            }

            DsButton {
                iconType: IconType.tablePlus
                text: qsTr("New Supply")
                onClicked: newproductpopup.open()
            }
        }

        DsSearchInputNoPopup {
            id: dsSearchInput
            busy: getSupplyRequest.running
            placeHolderText: qsTr("What are you looking for?")
            Layout.preferredHeight: Theme.lgBtnHeight
            Layout.fillWidth: true
            Layout.leftMargin: Theme.baseSpacing
            Layout.rightMargin: Theme.baseSpacing

            onAccepted: (txt) => getInventorySupply(txt)
        }

        DsTable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            headerModel: headermodel
            dataModel: datamodel
            busy: getSupplyRequest.running

            onSortBy: function(key) {
                if(key===sortByKey) {
                    sortAsc = !sortAsc;
                } else {
                    sortAsc = true;
                }

                sortByKey = key;

                getInventorySupply()
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.btnHeight
            Layout.bottomMargin: Theme.baseSpacing

            DsBusyIndicator {
                width: Theme.btnHeight
                height: Theme.btnHeight
                running: getSupplyRequest.running
                visible: running
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
            }

            Row {
                spacing: Theme.btnRadius
                anchors.right: parent.right
                anchors.rightMargin: Theme.baseSpacing

                DsLabel {
                    text: qsTr("Total Items  ") + `${totalItems}  `
                    color: Theme.txtHintColor
                    fontSize: Theme.smFontSize
                    anchors.verticalCenter: parent.verticalCenter
                }

                DsIconButton {
                    enabled: pageNo>1 && !getSupplyRequest.running
                    iconType: IconType.arrowLeft
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                    onClicked: {
                        pageNo -= 1
                        getInventorySupply()
                    }
                }

                DsLabel {
                    text: `${pageNo} / ${totalPages}`
                    color: Theme.txtHintColor
                    fontSize: Theme.smFontSize
                    anchors.verticalCenter: parent.verticalCenter
                }

                DsIconButton {
                    enabled: pageNo<totalPages && !getSupplyRequest.running
                    iconType: IconType.arrowRight
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                    onClicked: {
                        pageNo += 1
                        getInventorySupply()
                    }
                }
            }
        }
    }

    ListModel {
        id: headermodel

        ListElement {
            title: qsTr("Unit")
            sortable: true
            width: 100
            flex: 0
            value: "unit"
        }

        ListElement {
            title: qsTr("Product Name")
            sortable: true
            width: 300
            flex: 2
            value: "name"
        }

        ListElement {
            title: qsTr("Barcode")
            sortable: true
            width: 150
            flex: 0
            value: "barcode"
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

    Requests {
        id: getSupplyRequest
        baseUrl: "https://pb.digisto.app"
        path: "/api/collections/supply/records"
    }

    function getInventorySupply(txt='') {
        var query = {
            page: pageNo,
            perPage: itemsPerPage,
            sort: `${ sortAsc ? '+' : '-' }${ sortByKey }`,
            filter: "organization='clhyn7tolbhy98k'" + (txt==='' ? '' : ` && (name ~ '${txt}' || unit ~ '${txt}' || barcode ~ '${txt}')`)
        }

        getSupplyRequest.clear()
        getSupplyRequest.query = query;
        var res = getSupplyRequest.send();

        if(res.status===200) {
            var data = res.data;
            pageNo=data.page
            totalPages=data.totalPages
            totalItems=data.totalItems
            var items = data.items;

            datamodel.clear()

            for(var i=0; i<items.length; i++) {
                datamodel.append(items[i])
            }
        }

        else {

        }
    }

    Component.onCompleted: getInventorySupply()
}
