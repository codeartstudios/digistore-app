import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.platform
import app.digisto.modules

import "../controls"

DsPopup {
    id: root
    width: mainApp.width * 0.8
    height: mainApp.height * 0.75
    modal: true
    closePolicy: Popup.NoAutoClose

    property var selectedSupplier: null
    property ListModel supplyProductsModel: ListModel {}

    onOpened: clearInputs()

    contentItem: Item {
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.btnHeight
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.topMargin: Theme.xsSpacing

                DsLabel {
                    fontSize: Theme.h1
                    color: Theme.txtHintColor
                    text: qsTr("New Supply")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                }

                DsIconButton {
                    iconType: IconType.x
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                    radius: height/2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right

                    onClicked: root.close()
                }

            }

            // Line Separator
            Rectangle {
                height: 1
                color: Theme.shadowColor
                Layout.fillWidth: true
            } // Line Separator

            RowLayout {
                spacing: Theme.smSpacing
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing

                // ------------------------------------- //
                // SUPPLIER, SUPPLY COST & ATTACHMENTS   //
                // ------------------------------------- //
                DsSettingsStackPage {
                    Layout.fillHeight: true
                    implicitWidth: root.width/3
                    spacing: Theme.smSpacing

                    DsLabel {
                        color: Theme.txtHintColor
                        fontSize: Theme.baseFontSize
                        text: qsTr("Supply Information")
                        topPadding: Theme.xsSpacing
                    }

                    DsInputSelectorWithSearch {
                        id: supplierselector
                        label: qsTr("Select Supplier")
                        allowMultipleSelection: false
                        displayFields: ["name"]
                        collection: "suppliers"
                        searchInput.placeholderText: qsTr("Search the supplier by name ...")
                        width: parent.width
                    }

                    DsInputWithLabel {
                        id: amountinput
                        mandatory: true
                        label: qsTr("Total Cost in") + ` ${orgCurrency.symbol}`
                        input.placeholderText: qsTr("0.0")
                        width: parent.width
                        beforeItem: DsLabel {
                            text: orgCurrency.symbol
                            color: Theme.txtHintColor
                            fontSize: amountinput.input.font.pixelSize
                        }
                    }

                    DsInputWithLabel {
                        id: fileinput
                        label: qsTr("Supporting Docs")
                        input.placeholderText: qsTr(".pdf, .png, .jpg, .jpeg")
                        width: parent.width
                    }
                }

                // Line Separator
                Rectangle {
                    width: 1
                    color: Theme.shadowColor
                    Layout.fillHeight: true
                } // Line Separator

                // ------------------------------------- //
                // ITEM SEARCH BAR & SELECTED ITEMS LIST //
                // ------------------------------------- //
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Theme.xsSpacing

                    DsLabel {
                        color: Theme.txtHintColor
                        fontSize: Theme.baseFontSize
                        text: qsTr("Select items in this supply")
                        topPadding: Theme.xsSpacing
                    }

                    DsSearchInput { // Searchbar
                        id: searchBar
                        busy: getproductrequest.running
                        searchEnabled: dsPermissionManager.canViewInventory
                        placeHolderText: qsTr("Which item are you looking for?")
                        Layout.fillWidth: true

                        onTextChanged: (text) => searchItem(text)
                        onAccepted: (obj) => addOrUpdateItemInModel(obj)
                    } // Searchbar

                    DsBusyOrEmptyOrAccessDeniedTableItem {
                        accessAllowed: dsPermissionManager.canViewInventory
                        visible: root.supplyProductsModel.count === 0
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    } // Empty container

                    ListView {
                        id: supplyitemsListview
                        clip: true
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: Theme.btnRadius
                        model: root.supplyProductsModel
                        visible: root.supplyProductsModel.count > 0
                        delegate: DsSupplyProductEditItem {
                            id: editCurrentSupplyItem
                            selected: supplyitemsListview.currentIndex===index
                            width: supplyitemsListview.width
                        }
                    }
                }
            }

            // Line Separator
            Rectangle {
                height: 1
                color: Theme.shadowColor
                Layout.fillWidth: true
            } // Line Separator

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.btnHeight
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.bottomMargin: Theme.smSpacing
                Layout.topMargin: Theme.smSpacing

                Row {
                    spacing: Theme.smSpacing
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right

                    DsButton {
                        enabled: dsPermissionManager.canCreateSupply
                        busy: addproductrequest.running
                        text: qsTr("Add Supply")
                        iconType: IconType.plus
                        onClicked: addSupply()
                    }
                }
            }
        }
    }

    DsMessageBox {
        id: messageBox
        function showMessage(title="", info="") {
            messageBox.title = title
            messageBox.info = info
            messageBox.open()
        }
    }

    Requests {
        id: addproductrequest
        method: "POST"
        path: "/fn/create-supply"
        token: dsController.token
        baseUrl: dsController.baseUrl
    }

    Requests {
        id: getproductrequest
        token: dsController.token
        baseUrl: dsController.baseUrl
        path: "/api/collections/product/records"
    }

    function addOrUpdateItemInModel(model) {
        const id = model.id

        // Check if ID exists in the model already
        for(var i=0; i<root.supplyProductsModel.count; i++) {
            if(root.supplyProductsModel.get(i).id===id) {
                var qty = root.supplyProductsModel.get(i).quantity + 1
                root.supplyProductsModel.setProperty(i, "quantity", qty)
                supplyitemsListview.currentIndex = i
                return
            }
        }

        const obj = {
            id: model.id,
            quantity: 1,
            name: model.name,
            unit: model.unit,
            barcode: model.barcode,
            buying_price: model.buying_price,
            selling_price: model.selling_price
        }

        root.supplyProductsModel.append(obj)
        supplyitemsListview.currentIndex = root.supplyProductsModel.count - 1
    }

    function addSupply() {
        var am = parseFloat(amountinput.input.text.trim())
        var amount = am ? am : 0
        console.log(amount)

        if(amount <= 0) {
            messageBox.showMessage(qsTr("Supply Error!"),
                                   qsTr("Supply total cost is required!"))
            return;
        }

        if(root.supplyProductsModel.count === 0) {
            messageBox.showMessage(qsTr("Supply Error!"),
                                   qsTr("Products for the supply is required!"))
            return;
        }

        var products = []
        for(var i=0; i<root.supplyProductsModel.count; i++) {
            var p = root.supplyProductsModel.get(i)
            var product = {
                id: p.id,
                bp: p.buying_price,
                quantity: p.quantity,
                unit: p.unit,
                name: p.name
            }
            products.push(product)
        }

        var body = {
            amount,
            products,
            organization: dsController.workspaceId
        }

        if(supplierselector.dataModel.count!==0) {
            var supplierObj = supplierselector.dataModel.get(0)
            body['supplier'] = supplierObj.id;
        }

        addproductrequest.clear()
        addproductrequest.body = body
        var res = addproductrequest.send();
        console.log(JSON.stringify(res))

        if(res.status===200) {
            clearInputs()
            toast.success(qsTr("New supply added successfully!"))
        } else {
            messageBox.showMessage(qsTr("Create supply error!"),
                                   `${res.status}: ${res.data.message}`)
        }
    }

    function searchItem(input) {
        var query = {
            page: 1,
            perPage: 50,
            skipTotal: true,
            sort: '+name',
            filter: `organization = '${dsController.workspaceId}' && (barcode ~ '${input}' || name ~ '${input}' || unit ~ '${input}')`
        }

        getproductrequest.clear()
        getproductrequest.query = query;
        var res = getproductrequest.send();

        if(res.status===200) {
            var data = res.data;
            var items = data.items;

            searchBar.model.clear()

            for(var i=0; i<items.length; i++) {
                var obj = items[i]
                obj['fullname'] = `${obj.unit} ${obj.name}`
                searchBar.model.append(obj)
            }
        }

        else {
            searchBar.model.clear()
        }
    }

    function clearInputs() {
        amountinput.input.clear()
        supplierselector.dataModel.clear()
        fileinput.input.clear()
        root.supplyProductsModel.clear()
    }
}
