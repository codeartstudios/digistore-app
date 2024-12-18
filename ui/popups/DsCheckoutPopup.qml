import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.platform
import QtQuick.Controls.Basic
import app.digisto.modules

import "../controls"

Popup {
    id: root
    width: 800
    height: 600
    modal: true
    x: (mainApp.width-width)/2
    y: (mainApp.height-height)/2
    closePolicy: Popup.NoAutoClose

    property bool submitCheckoutEnabled: false

    // Passed in Data
    property real totals: 0
    property var model: null

    property ListModel paymentModel: ListModel{}

    signal checkoutSuccessful()

    onClosed: clearInputs()

    background: Rectangle {
        color: Theme.bodyColor
        radius: Theme.btnRadius
    }

    contentItem: Item {
        anchors.fill: parent

        ColumnLayout {
            spacing: Theme.smSpacing
            anchors.fill: parent
            anchors.leftMargin: Theme.baseSpacing
            anchors.rightMargin: Theme.baseSpacing
            anchors.bottomMargin: Theme.baseSpacing

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.btnHeight
                Layout.topMargin: Theme.xsSpacing

                Rectangle {
                    width: parent.width; height: 1
                    color: Theme.baseAlt1Color
                    anchors.bottom: parent.bottom
                }

                DsLabel {
                    fontSize: Theme.h1
                    color: Theme.txtHintColor
                    text: qsTr("Checkout > Payments")
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

            RowLayout {
                spacing: Theme.baseSpacing

                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 200

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        spacing: Theme.xsSpacing
                        clip: true
                        model: root.paymentModel
                        delegate: DsButton {
                            width: 250
                            height: 150
                            radius: Theme.btnRadius
                            bgColor: Theme.baseColor
                            bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                            bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                            contentItem: Item {
                                anchors.fill: parent

                                ColumnLayout {
                                    spacing: Theme.btnRadius
                                    anchors.fill: parent
                                    anchors.margins: Theme.btnRadius

                                    Image {
                                        fillMode: Image.PreserveAspectCrop
                                        source: model.image
                                        sourceSize.width: implicitWidth
                                        sourceSize.height: implicitHeight
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                    }

                                    DsLabel {
                                        color: Theme.txtPrimaryColor
                                        text: model.label
                                        fontSize: Theme.smFontSize
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }
                }

                ColumnLayout {
                    spacing: Theme.baseSpacing
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ScrollView {
                        id: scrollview
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Column {
                            width: scrollview.width
                            spacing: Theme.smSpacing

                            Row {
                                spacing: Theme.xsSpacing
                                anchors.horizontalCenter: parent.horizontalCenter

                                DsLabel {
                                    fontSize: Theme.h1
                                    color: Theme.txtHintColor
                                    text: qsTr("TOTALS")
                                    anchors.baseline: totalslabel.baseline
                                }

                                DsLabel {
                                    id: totalslabel
                                    isBold: true
                                    fontSize: Theme.btnHeight
                                    color: Theme.txtHintColor
                                    text: `KES ${totals}`
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            Rectangle {
                                width: parent.width; height: 1
                                color: Theme.baseAlt1Color
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Repeater {
                                id: paymentmethodsrepeater
                                signal recomputePaydVsTotals

                                model: paymentModel
                                delegate: DsCheckoutPaymentMethod {
                                    label: model.label
                                    input.placeholderText: qsTr("0.00")
                                    input.text: model.amount===0 ? '' : `${model.amount}`
                                    input.validator: DoubleValidator{bottom: 0}
                                    width: scrollview.width - 2*Theme.baseSpacing
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    onInputTextChanged: (val) => {
                                                            // console.log("Changed: ", val)
                                                            var num = parseFloat(val.trim())
                                                            val = isNaN(num) ? 0 : num
                                                            paymentModel.setProperty(index, "amount", val)
                                                            paymentmethodsrepeater.recomputePaydVsTotals()
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
                                busy: checkoutrequest.running
                                text: qsTr("Submit Payment")
                                endIcon: IconType.arrowRight
                                // iconType: IconType.plus
                                onClicked: submitSale()
                                enabled: root.submitCheckoutEnabled
                            }
                        }
                    }
                }
            }
        }
    }

    Requests {
        id: checkoutrequest
        path: "/fn/checkout"
        method: "POST"
    }

    Connections {
        target: paymentmethodsrepeater

        function onRecomputePaydVsTotals() {
            var payedSum = 0;

            for(var j=0; j<paymentModel.count; j++) {
                var paymentMethod = paymentModel.get(j)
                payedSum += paymentMethod.amount
            }

            root.submitCheckoutEnabled = root.totals > 0 && payedSum >= root.totals
        }
    }

    function submitSale() {
        if(!model) {
            messageBox.title = qsTr("Ooops!")
            messageBox.info = qsTr("We encountered a problem, the cart is empty! Pick some few items and try again.")
            messageBox.open()
            return;
        }

        var payments = {}
        for(var j=0; j<paymentModel.count; j++) {
            const paymentObject = paymentModel.get(j)
            // Set the payment uid key to payment object [JSON]
            payments[paymentObject.uid] = {
                label: paymentObject.label,
                uid: paymentObject.uid,
                type: paymentObject.type,
                amount: paymentObject.amount,
                data: paymentObject.data
            }
        }

        var products = []
        var mp = new Map();

        for(j=0; j<model.count; j++) {
            var obj = model.get(j)

            if(mp.has(obj.id)) {
                var indx = mp.get(obj.id)
                var old_obj = products[indx]
                var old_qty = old_obj.quantity
                var new_qty = old_qty + obj.quantity
                old_obj.quantity = new_qty
                products[indx] = old_obj
            } else {
                products.push({
                                  id: obj.id,
                                  name: obj.name,
                                  unit: obj.unit,
                                  barcode: obj.barcode,
                                  buying_price: obj.buying_price,
                                  selling_price: obj.selling_price,
                                  quantity: obj.quantity
                              })
                mp.set(obj.id, products.length-1)
            }
        }

        var body = {
            totals: root.totals,
            payments,
            organization: dsController.organizationID,
            products
        }

        checkoutrequest.clear()
        checkoutrequest.body = body
        console.log("Body: ", JSON.stringify(body))

        var res = checkoutrequest.send();
        console.log(JSON.stringify(res))

        if(res.status===200) {
            root.checkoutSuccessful()
            root.close()
        } else {
            messageBox.title = qsTr("Something went wrong!")
            messageBox.info = qsTr("Checkout process encontered an error, if the issue persists contact admin.")
            messageBox.open()
        }
    }

    function clearInputs() {
        root.totals = 0;
        root.model = null

        for(var j=0; j<paymentModel.count; j++) {
            paymentModel.setProperty(j, "amount",  0)
        }
    }

    Component.onCompleted: {
        paymentModel.append({
                                image: "qrc:/assets/imgs/payments/1.jpg",
                                label: "Cash",
                                uid: "cash",
                                type: "",
                                amount: 0,
                                data: {}
                            })

        paymentModel.append({
                                image: "qrc:/assets/imgs/payments/2.jpg",
                                label: "M-Pesa",
                                uid: "mpesa",
                                type: "",
                                amount: 0,
                                data: {}
                            })

        paymentModel.append({
                                image: "",
                                label: "Credit",
                                uid: "credit",
                                type: "",
                                amount: 0,
                                data: {}
                            })

        paymentModel.append({
                                image: "",
                                label: "Cheque",
                                uid: "cheque",
                                type: "",
                                amount: 0,
                                data: {}
                            })

    }

    onOpened: {
        // Update flags
        paymentmethodsrepeater.recomputePaydVsTotals()
    }
}
