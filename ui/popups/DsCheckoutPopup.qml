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
    property real totals: 1000
    property var model: null

    property ListModel paymentMethodsModel: ListModel{}
    property ListModel paymentModel: ListModel{}

    signal checkoutSuccessful()

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
                    text: qsTr("Checkout / Payments") + ` / KES ${root.totals}`
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

                Item {
                    Layout.preferredWidth: 200
                    Layout.fillHeight: true

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: Theme.xsSpacing

                        DsLabel {
                            color: Theme.txtHintColor
                            fontSize: Theme.lgFontSize
                            text: qsTr("Payment Methods")
                            Layout.fillWidth: true
                        }

                        ListView {
                            id: paymentModesLV
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            spacing: Theme.xsSpacing
                            clip: true
                            model: root.paymentMethodsModel
                            delegate: DsButton {
                                id: paymentModeLvDelegate
                                width: paymentModesLV.width
                                height: 150
                                radius: Theme.btnRadius
                                bgColor: Theme.baseColor
                                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                                onClicked: {
                                    var existsAtIndex = -1;

                                    // Find the index of the payment method in the payment Model
                                    for( var i=0; i<root.paymentModel.count; i++ ) {
                                        if( root.paymentModel.get(i).uid === model.uid ) {
                                            existsAtIndex = i;
                                            break;
                                        }
                                    }

                                    // If the payment method was not found, lets add it to the model
                                    if( existsAtIndex === -1 ) {
                                        const payment = {
                                            amount: paymentModel.count===0 ? root.totals : 0,
                                            label: model.label,
                                            uid: model.uid
                                        };

                                        root.paymentModel.append(payment)
                                        paymentMethodsLV.currentIndex = root.paymentModel.count - 1
                                    }

                                    else {
                                        // If we have added the method already, make it the current index
                                        // so that we can edit it.
                                        paymentMethodsLV.currentIndex = existsAtIndex;
                                    }
                                }

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

                                    Rectangle {
                                        visible: paymentModeLvDelegate.hovered
                                        anchors.fill: parent
                                        color: Qt.rgba(0,0,0,0.3)
                                        opacity: visible ? 1 : 0

                                        Behavior on opacity { NumberAnimation{} }

                                        DsIcon {
                                            iconType: IconType.categoryPlus
                                            color: Theme.baseColor
                                            iconSize: paymentModeLvDelegate.hovered ? Theme.lgBtnHeight : 0
                                            anchors.centerIn: parent

                                            Behavior on iconSize { NumberAnimation{} }
                                        }
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

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: root.paymentModel.count === 0

                        Column {
                            spacing: Theme.smSpacing
                            anchors.centerIn: parent

                            DsIcon {
                                iconSize: Theme.lgBtnHeight
                                iconType: IconType.scanPosition
                                color: Theme.txtHintColor
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            DsLabel {
                                color: Theme.txtHintColor
                                fontSize: Theme.lgFontSize
                                text: qsTr("No payment method selected, yet!")
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }

                    ListView {
                        id: paymentMethodsLV
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        signal recomputePaydVsTotals

                        visible: root.paymentModel.count > 0
                        currentIndex: -1
                        spacing: Theme.xsSpacing/2.0
                        model: root.paymentModel
                        delegate: DsCheckoutPaymentMethod {
                            property bool selected: paymentMethodsLV.currentIndex===index
                            property real amountPaid: model.amount

                            id: paymentMethodDelegate
                            label: model.label
                            width: paymentMethodsLV.width
                            readOnly: !paymentMethodDelegate.selected || !forceInputActiveFocusOnClick
                            forceInputActiveFocusOnClick: model.uid !== "cash"
                            input.placeholderText: qsTr("0.0")
                            input.text: model.amount===0 ? '' : model.amount.toString()
                            input.validator: DoubleValidator{ bottom: 0 }

                            onInputTextChanged: (val) => amountUpdated(val)
                            onClicked: paymentMethodsLV.currentIndex = index
                            onRemovePayment: removePaymentMethod()
                            onSelectedChanged: if(selected) input.forceActiveFocus(Qt.MouseFocusReason)
                            onAmountPaidChanged: input.text = model.amount;

                            function amountUpdated(val) {
                                var num = parseFloat(val.trim())
                                val = isNaN(num) ? 0 : num
                                root.paymentModel.setProperty(index, "amount", val)

                                updateCashPaymentAmount(model.uid)
                                paymentMethodsLV.recomputePaydVsTotals()
                            }

                            function removePaymentMethod() {
                                root.paymentModel.remove(index)
                                updateCashPaymentAmount("")
                                paymentMethodsLV.recomputePaydVsTotals()
                            }

                            Component.onCompleted: input.text = model.amount;
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
        method: "POST"
        path: "/fn/checkout"
        token: dsController.token
        baseUrl: dsController.baseUrl
    }

    Connections {
        target: paymentMethodsLV

        function onRecomputePaydVsTotals() {
            var payedSum = 0;

            for(var j=0; j<root.paymentModel.count; j++) {
                var paymentMethod = root.paymentModel.get(j)
                payedSum += paymentMethod.amount
            }

            root.submitCheckoutEnabled = root.totals > 0 && payedSum >= root.totals
        }
    }

    function submitSale() {
        if(!model) {
            showMessage(
                        qsTr("Ooops!"),
                        qsTr("We encountered a problem, the cart is empty! Pick some few items and try again.")
                        )
            return;
        }

        var paymentTotals = 0;
        var cashPayment = 0;

        // Compute payment totals vs checkout totals
        for(var j=0; j<paymentModel.count; j++) {
            const paymentObject = paymentModel.get(j)
            paymentTotals += paymentObject.amount

            // Record cash payment done for computing balance due.
            if(paymentObject.uid === 'cash') cashPayment = paymentObject.amount;
        }

        if(paymentTotals === 0) {
            showMessage("Payment Error",
                        "Payment Methods Are Zero")
            return
        }

        if(paymentTotals < root.totals) {
            showMessage("Payment Error",
                        "Payments can't be less than cart totals.")
            return
        }

        if(paymentTotals > root.totals) {
            showMessage("Payment Error",
                        "Payments can't exeed the cart totals.")
            return
        }

        var payments = {}
        for(let j=0; j<paymentModel.count; j++) {
            const paymentObject = paymentModel.get(j)
            if(paymentObject.amount > 0) { // Only append if value is non zero
                // Set the payment uid key to payment object [JSON]
                payments[paymentObject.uid] = {
                    label: paymentObject.label,
                    uid: paymentObject.uid,
                    type: paymentObject.type,
                    amount: paymentObject.amount,
                    data: paymentObject.data
                }
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
            }
            else {
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
            organization: dsController.workspaceId,
            products
        }

        checkoutrequest.clear()
        checkoutrequest.body = body

        var res = checkoutrequest.send();
        // console.log(JSON.stringify(res))

        if(res.status===200) {
            // If we dont have cash payment, just end the session
            if(cashPayment === 0) {
                completeCheckoutSession()
                toast.info(qsTr("Checkout Successful!"))
            }

            // Spin up cash input popup, otherwise
            else {
                console.log("Opening checkout complete dialog")
                // Open the amount entry dialog, compute balance
                checkoutCompletePopup.open()
                checkoutCompletePopup.cashAmountPaid = cashPayment;
            }
        }

        else {
            messageBox.title = qsTr("Checkout failed!")
            messageBox.info = res.data.message ? res.data.message : qsTr("Checkout process encontered an error, if the issue persists contact admin.")
            messageBox.open()
        }
    }

    function completeCheckoutSession() {
        root.checkoutSuccessful()
        dsController.emitOpenCashDrawer()
        root.close()
    }

    function clearInputs() {
        root.totals = 0;
        root.model = null
        paymentMethodsLV.currentIndex = -1
    }

    // TODO
    // Adding cash later after removing it does not
    // update cash value to the full
    function updateCashPaymentAmount(uid) {
        var cash = { index: -1, amount: 0}
        var paidSum = 0;

        // Get cash payment data
        for(var i=0; i<paymentModel.count; i++) {
            if( paymentModel.get(i).uid === 'cash' ) {
                cash.amount = paymentModel.get(i).amount
                cash.index = i
            }

            else {
                paidSum += paymentModel.get(i).amount
            }
        }

        if( paidSum <= root.totals && cash.amount > 0 && cash.index >= 0) {
            root.paymentModel.setProperty(cash.index, "amount", root.totals - paidSum)
        }
    }

    Component.onCompleted: {
        paymentMethodsModel.clear()

        paymentMethodsModel.append({
                                       image: "qrc:/assets/imgs/payments/1.jpg",
                                       label: "Cash",
                                       uid: "cash"
                                   })

        paymentMethodsModel.append({
                                       image: "qrc:/assets/imgs/payments/2.jpg",
                                       label: "M-Pesa",
                                       uid: "mpesa"
                                   })

        paymentMethodsModel.append({
                                       image: "qrc:/assets/imgs/payments/3.png",
                                       label: "On Credit",
                                       uid: "credit"
                                   })

        paymentMethodsModel.append({
                                       image: "qrc:/assets/imgs/payments/4.png",
                                       label: "PDQ (Card)",
                                       uid: "pdq"
                                   })

        paymentMethodsModel.append({
                                       image: "qrc:/assets/imgs/payments/5.png",
                                       label: "Cheque",
                                       uid: "cheque"
                                   })

    }

    onOpened: {
        // Update flags
        paymentMethodsLV.recomputePaydVsTotals()
        paymentMethodsLV.currentIndex = -1
    }

    onClosed: {
        clearInputs()
        paymentModel.clear()
    }

    // Popups
    DsCheckoutCompletePopup{ id: checkoutCompletePopup }
}
