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
                text: qsTr("Products")
                Layout.alignment: Qt.AlignVCenter
            }

            DsIconButton {
                enabled: !getproductrequest.running
                iconType: IconType.reload
                textColor: Theme.txtPrimaryColor
                bgColor: "transparent"
                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                radius: height/2
                Layout.alignment: Qt.AlignVCenter

                onClicked: getProducts()
            }

            Item {
                Layout.fillWidth: true
                height: 1
            }

            DsMenu {
                id: toolsMenu
                iconType: IconType.databaseCog
                text: qsTr("Options")

                Component.onCompleted: {
                    menuModel.clear()

                    menuModel.append({
                                         label: "Add New Product",
                                         icon: IconType.databasePlus
                                     })

                    menuModel.append({
                                         label: "Add New Supplier",
                                         icon: IconType.playlistAdd
                                     })

                    menuModel.append({ type: "spacer" })

                    menuModel.append({
                                         label: "View All Suppliers",
                                         icon: IconType.layoutList
                                     })

                    menuModel.append({
                                         label: "Supply History",
                                         icon: IconType.databaseImport
                                     })
                }
            }
        }

        DsSearchInputNoPopup {
            id: dsSearchInput
            busy: getproductrequest.running
            placeHolderText: qsTr("What are you looking for?")
            Layout.preferredHeight: Theme.lgBtnHeight
            Layout.fillWidth: true
            Layout.leftMargin: Theme.baseSpacing
            Layout.rightMargin: Theme.baseSpacing

            onAccepted: getProducts()
        }

        DsTable {
            id: inventorytable
            Layout.fillWidth: true
            Layout.fillHeight: true
            headerModel: headermodel
            dataModel: datamodel
            busy: getproductrequest.running

            onSortBy: function(key) {
                if(key===sortByKey) {
                    sortAsc = !sortAsc;
                } else {
                    sortAsc = true;
                }

                sortByKey = key;

                getProducts()
            }

            onSelectionChanged: (index, model) => {
                                    launchEditOrViewDrawer(index, model)
                                }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.btnHeight
            Layout.bottomMargin: Theme.baseSpacing

            DsBusyIndicator {
                width: Theme.btnHeight
                height: Theme.btnHeight
                running: getproductrequest.running
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
                    enabled: pageNo>1 && !getproductrequest.running
                    iconType: IconType.arrowLeft
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                    onClicked: {
                        pageNo -= 1
                        getProducts()
                    }
                }

                DsLabel {
                    text: `${pageNo} / ${totalPages}`
                    color: Theme.txtHintColor
                    fontSize: Theme.smFontSize
                    anchors.verticalCenter: parent.verticalCenter
                }

                DsIconButton {
                    enabled: pageNo<totalPages && !getproductrequest.running
                    iconType: IconType.arrowRight
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                    onClicked: {
                        pageNo += 1
                        getProducts()
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

    DsNewSupplierPopup {
        id: newsupplierpopup
    }

    DsViewOrEditProductDrawer {
        id: vieworeditdrawer

        onClosed: inventorytable.currentIndex=-1
        onProductAdded: getProducts()
        onProductDeleted: getProducts()
        onProductUpdated: getProducts()
    }

    DsSupplierViewPopup {
        id: supplierviewpopup
    }

    DsSupplyHistoryViewPopup {
        id: supplyhistorypopup
    }

    Requests {
        id: getproductrequest
        token: dsController.token
        baseUrl: dsController.baseUrl
        path: "/api/collections/product/records"
    }

    function getProducts() {
        var txt = dsSearchInput.text.trim()
        var query = {
            page: pageNo,
            perPage: itemsPerPage,
            sort: `${ sortAsc ? '+' : '-' }${ sortByKey }`,
            filter: `organization = '${dsController.workspaceId}'` +
                    (txt==='' ? '' : ` && (name ~ '${txt}' || unit ~ '${txt}' || barcode ~ '${txt}')`)
        }

        getproductrequest.clear()
        getproductrequest.query = query;
        var res = getproductrequest.send();

        if(res.status===200) {
            var data = res.data;
            pageNo=data.page
            totalPages=data.totalPages
            totalItems=data.totalItems
            var items = data.items;

            datamodel.clear()

            // Workaround to get tags:['str'] extractable later
            for(var i=0; i<items.length; i++) {
                var tags = []
                var obj = items[i]
                if(!obj.tags) obj.tags = []
                obj.tags.forEach((tag) => {
                                     tags.push({ data: tag })
                                 })
                obj.tags = tags
                datamodel.append(obj)
            }
        }

        else {
            showMessage(
                        qsTr("Error fetching products"),
                        qsTr("There was an issue when fetching products: ") + `[${res.status}]${res.data.message}`
                        )
        }
    }

    function launchEditOrViewDrawer(index, model) {
        var obj = {
            id: model.id,
            collectionId: model.collectionId,
            created: model.created,
            name: model.name,
            unit: model.unit,
            tags: model.tags,
            barcode: model.barcode,
            buying_price: model.buying_price,
            selling_price: model.selling_price,
            stock: model.stock,
            thumbnail: model.thumbnail,
            organization: model.organization
        }

        vieworeditdrawer.open()
        vieworeditdrawer.dataModel = obj
        vieworeditdrawer.isEditing = false
    }

    Component.onCompleted: getProducts()

    // Handle menu selection in the products tab
    Connections {
        target: toolsMenu

        function onCurrentMenuChanged(index) {
            switch(index) {
            case 0: {
                vieworeditdrawer.open()
                vieworeditdrawer.dataModel = null
                vieworeditdrawer.isEditing = true
                break;
            }

            case 1: {
                newsupplierpopup.open()
                break;
            }

            // This is a spacer item
            case 2: break;

            case 3: {
                supplierviewpopup.open()
                break;
            }

            case 4: {
                // TODO open this popup
                supplyhistorypopup.open()
                break;
            }
            }
        }
    }
}
