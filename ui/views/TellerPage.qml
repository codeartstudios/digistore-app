import QtQuick
import QtQuick.Controls
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
                text: qsTr("Home")
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
                text: qsTr("Teller")
                Layout.alignment: Qt.AlignVCenter
            }

            DsIconButton {
                enabled: !searchitemrequest.running
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
                        width: 80
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
                        text: qsTr("KES ") + `${checkoutTotals}`
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
                iconType: IconType.basketShare
                text: qsTr("Checkout")
                Layout.preferredHeight: Theme.lgBtnHeight
                // onClicked: newproductpopup.open()
            }

            DsButton {
                iconType: IconType.handStop
                text: qsTr("Freeze")
                Layout.preferredHeight: Theme.lgBtnHeight
                // onClicked: newproductpopup.open()
            }
        }

        DsSearchInput {
            id: dsSearchInput
            model: searchModel
            busy: searchitemrequest.running
            placeHolderText: qsTr("What are you looking for?")
            Layout.preferredHeight: Theme.lgBtnHeight
            Layout.fillWidth: true
            Layout.leftMargin: Theme.baseSpacing
            Layout.rightMargin: Theme.baseSpacing

            onTextChanged: function (text) {
                searchItem(text)
            }

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
                cartModel.append(cartObj)
                calculateTotals()
            }
        }

        DsTable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            headerModel: ListModel{ id: headermodel }
            dataModel: cartModel
            busy: searchitemrequest.running
            headerAcionIconType: IconType.eraser
            delegateActionIconType: IconType.shoppingBagEdit

            onHeaderActionButtonSelected: {
                cartModel.clear()
                calculateTotals()
            }

            onDelegateActionButtonSelected: function(index, model) {
                console.log(index, model)
            }

            Component.onCompleted: addheaders()
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.btnHeight
            Layout.bottomMargin: Theme.baseSpacing

            DsBusyIndicator {
                width: Theme.btnHeight
                height: Theme.btnHeight
                running: searchitemrequest.running
                visible: running
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
            }

            Row {
                spacing: Theme.btnRadius
                anchors.right: parent.right
                anchors.rightMargin: Theme.baseSpacing

                DsLabel {
                    // text: qsTr("Total Items  ") + `${totalItems}  `
                    color: Theme.txtHintColor
                    fontSize: Theme.smFontSize
                    anchors.verticalCenter: parent.verticalCenter
                }

                DsIconButton {
                    // enabled: pageNo>1 && !searchitemrequest.running
                    iconType: IconType.arrowLeft
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                    onClicked: {
                        //pageNo -= 1
                        getProducts()
                    }
                }

                DsLabel {
                    // text: `${pageNo} / ${totalPages}`
                    color: Theme.txtHintColor
                    fontSize: Theme.smFontSize
                    anchors.verticalCenter: parent.verticalCenter
                }

                DsIconButton {
                    // enabled: pageNo<totalPages && !searchitemrequest.running
                    iconType: IconType.arrowRight
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                    onClicked: {
                        // pageNo += 1
                        getProducts()
                    }
                }
            }
        }
    }

    // Components
    DsNewProductPopup {
        id: newproductpopup
    }

    Requests {
        id: searchitemrequest
        baseUrl: "https://pb.digisto.app"
        path: "/api/collections/product/records"
    }

    function getProducts() {}

    function searchItem(input) {
        var query = {
            page: 1,
            perPage: 50,
            skipTotal: true,
            sort: '+name',
            filter: `name ~ '${input}' || unit ~ '${input}'`
        }
        // organization: "clhyn7tolbhy98k"

        searchitemrequest.clear()
        searchitemrequest.query = query;
        var res = searchitemrequest.send();

        // console.log(JSON.stringify(res))

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
