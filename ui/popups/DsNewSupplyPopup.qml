import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.platform
import app.digisto.modules

import "../controls"

Popup {
    id: root
    width: mainApp.width * 0.7
    height: mainApp.height * 0.7
    modal: true
    x: (parent.width-width)/2
    y: (parent.height-height)/2
    closePolicy: Popup.NoAutoClose

    property var selectedSupplier: null
    property ListModel supplyProductsModel: ListModel {}

    onOpened: clearInputs()

    background: Rectangle {
        color: Theme.bodyColor
        radius: Theme.btnRadius
    }

    contentItem: Item {
        anchors.fill: parent

        ColumnLayout {
            spacing: Theme.baseSpacing
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

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing

                ColumnLayout {
                    anchors.fill: parent
                    spacing: Theme.xsSpacing

                    Row {
                        spacing: Theme.smSpacing
                        Layout.fillWidth: true

                        DsInputSelectorWithSearch {
                            id: supplierselector
                            label: qsTr("Select Supplier")
                            allowMultipleSelection: false
                            displayFields: ["name"]
                            collection: "suppliers"
                            searchInput.placeholderText: qsTr("Search the supplier by name ...")
                            width: (parent.width-parent.spacing*2)/3
                        }

                        DsInputWithLabel {
                            id: amountinput
                            mandatory: true
                            label: qsTr("Total Cost")
                            input.placeholderText: qsTr("0.0")
                            width: (parent.width-parent.spacing*2)/3
                        }

                        DsInputWithLabel {
                            id: fileinput
                            label: qsTr("Supporting Docs")
                            input.placeholderText: qsTr(".pdf, .png, .jpg, .jpeg")
                            width: (parent.width-parent.spacing*2)/3
                        }
                    }

                    Rectangle {
                        color: Theme.baseAlt1Color
                        radius: Theme.btnRadius
                        height: qtyiwl.height + Theme.xsSpacing
                        Layout.fillWidth: true

                        RowLayout {
                            spacing: Theme.xsSpacing/2
                            anchors.fill: parent
                            anchors.margins: Theme.xsSpacing/2

                            DsInputSelectorWithSearch {
                                id: productselector
                                collection: "product"
                                displayFields: ["unit", "name"]
                                label: qsTr("Product")
                                allowMultipleSelection: false
                                mandatory: true
                                color: withOpacity(Theme.baseAlt2Color, 0.6)
                                Layout.preferredHeight: qtyiwl.implicitHeight
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                            }

                            DsInputWithLabel {
                                id: qtyiwl
                                label: qsTr("Quantity")
                                color: withOpacity(Theme.baseAlt2Color, 0.6)
                                validator: IntValidator{ bottom: 1 }
                                input.placeholderText: "1"
                                mandatory: true
                                Layout.preferredWidth: 100
                                Layout.alignment: Qt.AlignVCenter
                            }

                            DsInputWithLabel {
                                id: bpiwl
                                label: qsTr("Buying Price")
                                color: withOpacity(Theme.baseAlt2Color, 0.6)
                                validator: DoubleValidator{ bottom: 1 }
                                input.placeholderText: "0.0"
                                mandatory: true
                                Layout.preferredWidth: 100
                                Layout.alignment: Qt.AlignVCenter
                            }

                            DsIconButton {
                                Layout.preferredHeight: qtyiwl.height
                                Layout.preferredWidth: Theme.btnHeight
                                radius: Theme.btnRadius
                                iconType: IconType.plus

                                onClicked: {
                                    if(productselector.dataModel.count===0) {
                                        showMessage(qsTr("Supply Error"),
                                                    qsTr("No product selected yet!"))
                                        return
                                    }

                                    if(qtyiwl.input.text <= 0) {
                                        showMessage(qsTr("Supply Error"),
                                                    qsTr("Stock quantity is required!"))
                                        return
                                    }

                                    if(bpiwl.input.text <= 0) {
                                        showMessage(qsTr("Supply Error"),
                                                    qsTr("Buying price is required!"))
                                        return
                                    }

                                    var product = productselector.dataModel.get(0)
                                    var item = {
                                        product: {
                                            barcode: product.barcode,
                                            selling_price: product.selling_price,
                                            unit: product.unit,
                                            buying_price: product.buying_price,
                                            name: product.name,
                                            tags: product.tags,
                                            id: product.id,
                                            created: product.created,
                                            stock: product.stock,
                                            thumbnail: product.thumbnail
                                        },
                                        quantity: qtyiwl.input.text,
                                        buying_price: bpiwl.input.text
                                    }

                                    root.supplyProductsModel.append(item)
                                    clearAddProductsInputs() // Clear fields
                                }
                            }
                        }
                    }

                    RowLayout {
                        Layout.preferredHeight: Theme.inputHeight
                        Layout.fillWidth: true
                        spacing: Theme.xsSpacing

                        DsLabel {
                            text: qsTr("Supply Items")
                            color: Theme.txtHintColor
                            fontSize: Theme.baseFontSize
                            Layout.preferredHeight: Theme.xsBtnHeight
                            verticalAlignment: DsLabel.AlignVCenter
                        }

                        Rectangle {
                            Layout.preferredHeight: 1
                            Layout.fillWidth: true
                            color: Theme.baseAlt1Color
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: root.supplyProductsModel.count === 0

                        DsLabel {
                            fontSize: Theme.baseFontSize
                            color: Theme.txtHintColor
                            text: qsTr("No supply items added yet!")
                            anchors.centerIn: parent
                        }
                    }

                    ListView {
                        id: splv
                        clip: true
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: Theme.btnRadius
                        model: root.supplyProductsModel
                        visible: root.supplyProductsModel.count > 0
                        delegate: Rectangle {
                            height: Theme.inputHeight + 2*Theme.btnRadius
                            width: splv.width
                            color: Theme.baseAlt1Color
                            radius: Theme.btnRadius

                            RowLayout {
                                spacing: Theme.xsSpacing
                                anchors.fill: parent
                                anchors.margins: Theme.btnRadius

                                // Product Name
                                DsLabel {
                                    text: `${model.product.unit} ${model.product.name}`
                                    color: Theme.txtPrimaryColor
                                    fontSize: Theme.baseFontSize
                                    leftPadding: Theme.btnRadius
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                // Quantity & price
                                DsLabel {
                                    text: `${model.quantity} x KES. ${model.buying_price}`
                                    color: Theme.txtPrimaryColor
                                    fontSize: Theme.baseFontSize
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                DsIconButton {
                                    iconType: IconType.x
                                    textColor: Theme.dangerColor
                                    iconSize: Theme.xsBtnHeight
                                    bgColor: "transparent"
                                    bgHover: withOpacity(Theme.dangerAltColor, 0.8)
                                    bgDown: withOpacity(Theme.dangerAltColor, 0.6)

                                    Layout.preferredWidth: Theme.inputHeight
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignVCenter

                                    onClicked: root.supplyProductsModel.remove(index)
                                }
                            }
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.btnHeight
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.bottomMargin: Theme.baseSpacing

                Row {
                    spacing: Theme.smSpacing
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right

                    DsButton {
                        busy: addproductrequest.running
                        text: qsTr("Add")
                        iconType: IconType.plus
                        onClicked: addSupply()
                    }
                }
            }
        }
    }

    Requests {
        id: addproductrequest
        method: "POST"
        path: "/fn/create-supply"
        token: dsController.token
        baseUrl: dsController.baseUrl
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
                id: p.product.id,
                bp: p.product.buying_price,
                quantity: p.quantity,
                unit: p.product.unit,
                name: p.product.name
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
        // console.log(JSON.stringify(res))

        if(res.status===200) {
            clearInputs()
            toast.success(qsTr("New supply added successfully!"))
        } else {
            messageBox.showMessage(qsTr("Create supply error!"),
                                   `${res.status}: ${res.data.message}`)
        }
    }

    function clearAddProductsInputs() {
        qtyiwl.input.clear()
        bpiwl.input.clear()
        productselector.dataModel.clear()
    }

    function clearInputs() {
        clearAddProductsInputs()
        amountinput.input.clear()
        supplierselector.dataModel.clear()
        fileinput.input.clear()
    }

    DsMessageBox {
        id: messageBox
        z: parent.z
        x: (root.width-width)/2
        y: (root.height-height)/2

        function showMessage(title="", info="") {
            messageBox.title = title
            messageBox.info = info
            messageBox.open()
        }
    }
}
