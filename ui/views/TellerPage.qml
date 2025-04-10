import QtQuick
import QtQuick.Controls.Basic as QQCB
import QtQuick.Layouts
import app.digisto.modules

import "../controls"
import "../popups"

DsPage {
    id: tellerpage
    title: ""
    headerShown: false

    property ListModel searchModel: ListModel{}
    property ListModel cartModel: ListModel{}
    property real checkoutTotals: 0

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
                text: qsTr("Digisto")
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
                text: qsTr("Cashier")
                Layout.alignment: Qt.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
                height: 1
            }

            Rectangle {
                height: Theme.lgBtnHeight
                border.width: 1
                border.color: Theme.dangerAltColor
                color: "transparent"
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: totalsrow.width

                Row {
                    id: totalsrow
                    height: parent.height

                    Rectangle {
                        height: parent.height
                        width: 100
                        radius: Theme.btnRadius
                        color: Theme.dangerAltColor

                        DsLabel {
                            text: qsTr("TOTALS")
                            fontSize: Theme.h2
                            color: Theme.txtPrimaryColor
                            isBold: true
                            anchors.centerIn: parent
                        }
                    }

                    DsLabel {
                        text: `${orgCurrency.symbol} ${checkoutTotals}`
                        fontSize: Theme.h1
                        color: Theme.txtPrimaryColor
                        isBold: true
                        leftPadding: Theme.baseSpacing
                        rightPadding: Theme.baseSpacing
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            DsButton {
                enabled: cartModel.count > 0 &&
                         dsPermissionManager.isCashier
                iconType: IconType.basketShare
                text: qsTr("Checkout")
                Layout.preferredHeight: Theme.lgBtnHeight

                onClicked: {
                    if(dsPermissionManager.isCashier) {
                        checkoutpopup.open()
                        checkoutpopup.totals = checkoutTotals
                        checkoutpopup.model = cartModel
                    } else {
                        toast.warning("You don't have permissions to do this action!")
                    }
                }
            }
        }

        DsSearchInput {
            id: dsSearchInput
            model: searchModel
            searchEnabled: dsPermissionManager.isCashier
            busy: searchitemrequest.running
            placeHolderText: qsTr("What are you looking for?")
            Layout.preferredHeight: Theme.lgBtnHeight
            Layout.fillWidth: true
            Layout.leftMargin: Theme.baseSpacing
            Layout.rightMargin: Theme.baseSpacing

            onTextChanged: function (text) {
                searchItem(text)
            }

            onEnabledChanged: console.log('Enabled Changed: ', enabled, dsPermissionManager.isCashier)

            onAccepted: function(obj) {
                var quantity = 1;
                var cartObj = {
                    id: obj.id,
                    collectionId: obj.collectionId,
                    fullname: `${obj.unit} ${obj.name}`,
                    name: obj.name,
                    unit: obj.unit,
                    barcode: obj.barcode,
                    buying_price: obj.buying_price,
                    selling_price: obj.selling_price,
                    stock: obj.stock,
                    thumbnail: obj.thumbnail,
                    organization: obj.organization,
                    quantity,
                    subtotal: quantity * obj.selling_price
                }

                // Push new item to cart model
                cartModel.append(cartObj)

                // Recalculate cart totals on append
                calculateTotals()

                // Force the current index for the table to
                // remain on last added item, that way the
                // added item can be edited immediately
                table.currentIndex = cartModel.count - 1
                if(table.currentIndex >= 0)
                    table.selectionChanged(table.currentIndex, cartModel.get(table.currentIndex))
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            DsTable {
                id: table
                headerModel: ListModel{ id: headermodel }
                dataModel: cartModel
                busy: searchitemrequest.running
                headerAcionIconType: IconType.eraser
                delegateActionIconType: IconType.shoppingBagEdit
                accessAllowed: dsPermissionManager.isCashier
                anchors.fill: parent

                onHeaderActionButtonSelected: {
                    table.currentIndex = -1
                    cartModel.clear()
                    calculateTotals()
                }

                onDelegateActionButtonSelected: function(index, model) {
                    currentIndex=index;
                    selectionChanged(index, model);
                }

                onCurrentIndexChanged: if(table.currentIndex===-1)
                                           selectedObjectItem.selectedObject=null

                onSelectionChanged: function(_, obj) {
                    selectedObjectItem.selectedObject={
                        id: obj.id,
                        collectionId: obj.collectionId,
                        fullname: `${obj.unit} ${obj.name}`,
                        name: obj.name,
                        unit: obj.unit,
                        barcode: obj.barcode,
                        buying_price: obj.buying_price,
                        selling_price: obj.selling_price,
                        stock: obj.stock,
                        thumbnail: obj.thumbnail,
                        organization: obj.organization,
                        quantity: obj.quantity,
                        subtotal: obj.quantity * obj.selling_price
                    }
                }

                // Build headers
                Component.onCompleted: addheaders()
            }

        }

        Rectangle {
            id: selectedObjectItem
            color: Theme.shadowColor
            radius: Theme.btnRadius
            visible: selectedObject
            implicitHeight: selectedObject ? Theme.lgBtnHeight : 0
            Layout.fillWidth: true
            Layout.leftMargin: Theme.smSpacing
            Layout.rightMargin: Theme.smSpacing
            Layout.bottomMargin: Theme.baseSpacing

            Behavior on implicitHeight { NumberAnimation {} }

            property var selectedObject: null

            DsBusyIndicator {
                width: Theme.btnHeight
                height: Theme.btnHeight
                running: searchitemrequest.running
                visible: running
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
            }

            RowLayout {
                spacing: Theme.btnRadius
                anchors.fill: parent
                anchors.rightMargin: Theme.xsSpacing/2
                anchors.leftMargin: Theme.xsSpacing/2

                property alias obj: selectedObjectItem.selectedObject

                DsIconButton {
                    enabled: !searchitemrequest.running
                    iconType: IconType.x
                    textColor: Theme.dangerColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.dangerAltColor, 0.8)
                    bgDown: withOpacity(Theme.dangerAltColor, 0.6)
                    radius: height/2
                    Layout.alignment: Qt.AlignVCenter

                    onClicked: table.currentIndex=-1
                }

                DsLabel {
                    text: qsTr("Name")
                    color: Theme.txtHintColor
                    fontSize: Theme.lgFontSize
                    rightPadding: Theme.smSpacing
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: Theme.smSpacing
                }

                DsLabel {
                    text: parent.obj ? `${parent.obj.unit} ${parent.obj.name}` : ""
                    color: Theme.txtPrimaryColor
                    fontSize: Theme.lgFontSize
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                }

                DsLabel {
                    text: qsTr("Quantity")
                    color: Theme.txtHintColor
                    fontSize: Theme.lgFontSize
                    rightPadding: Theme.smSpacing
                    Layout.alignment: Qt.AlignVCenter
                }

                QQCB.SpinBox {
                    id: qtysbox
                    Layout.preferredHeight: Theme.btnHeight
                    Layout.preferredWidth: 200
                    value: parent.obj ? parent.obj.quantity : 1
                    from: 1
                    editable: true
                }

                Item { height: 1; Layout.preferredWidth: 50 }

                DsButton {
                    text: qsTr("Update")
                    iconType: IconType.circleCheck

                    onClicked: {
                        var index = table.currentIndex
                        var qty = qtysbox.value
                        var sp = parent.obj.selling_price

                        cartModel.set(index, { quantity: qty, subtotal: qty*sp })
                        calculateTotals()

                        table.currentIndex=-1
                    }
                }

                DsButton {
                    text: qsTr("Remove")
                    iconType: IconType.trashX
                    textColor: Theme.dangerColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.dangerAltColor, 0.8)
                    bgDown: withOpacity(Theme.dangerAltColor, 0.6)
                    borderColor: Theme.dangerColor
                    borderWidth: 1

                    onClicked: {
                        cartModel.remove(table.currentIndex);
                        calculateTotals();
                    }
                }
            }
        }
    }

    // Components
    DsCheckoutPopup {
        id: checkoutpopup
        totals: root.checkoutTotals ? root.checkoutTotals : 0
        model: root.cartModel

        // On successful checkout, clear cart model and search input
        onCheckoutSuccessful: {
            cartModel.clear()
            searchitemrequest.clear()
            calculateTotals()
        }
    }

    Requests {
        id: searchitemrequest
        token: dsController.token
        baseUrl: dsController.baseUrl
        path: "/api/collections/product/records"
    }

    function getProducts() {}

    function searchItem(input) {
        var query = {
            page: 1,
            perPage: 50,
            skipTotal: true,
            sort: '+name',
            filter: `organization = '${dsController.workspaceId}' && (barcode ~ '${input}' || name ~ '${input}' || unit ~ '${input}')`
        }

        searchitemrequest.clear()
        searchitemrequest.query = query;
        var res = searchitemrequest.send();

        if(res.status===200) {
            var data = res.data;
            var items = data.items;

            searchModel.clear()

            for(var i=0; i<items.length; i++) {
                var obj = items[i]
                obj['fullname'] = `${obj.unit} ${obj.name}`
                searchModel.append(obj)
            }
        }

        else {
            searchModel.clear()
        }
    }

    function calculateTotals() {
        var totals = 0;

        // Recalculate totals when the data changes
        for(var i=0; i<cartModel.count; i++) {
            var obj = cartModel.get(i);
            totals += obj.selling_price * obj.quantity;
        }

        checkoutTotals = totals;
    }

    function addheaders() {
        headermodel.append(
                    [
                        {
                            title: qsTr("Barcode"),
                            sortable: false,
                            width: 150,
                            flex: 0,
                            value: "barcode"
                        },
                        {
                            title: qsTr("Product Name"),
                            sortable: false,
                            width: 300,
                            flex: 2,
                            value: "fullname"
                        },
                        {
                            title: qsTr("Quantity"),
                            sortable: false,
                            width: 200,
                            flex: 1,
                            value: "quantity"
                        },
                        {
                            title: qsTr("Selling Price"),
                            sortable: false,
                            width: 200,
                            flex: 1,
                            value: "selling_price"
                        },
                        {
                            title: qsTr("Sub Total"),
                            sortable: false,
                            width: 200,
                            flex: 1,
                            value: "subtotal"
                        }
                    ])
    }
}
