import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.platform
import app.digisto.modules

import "../controls"

Popup {
    id: root
    width: 500
    height: 600
    modal: true
    x: (mainApp.width-width)/2
    y: (mainApp.height-height)/2
    closePolicy: Popup.NoAutoClose

    onOpened: clearInputs()

    property real totals: 0
    property var model: null

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

                Rectangle {
                    width: parent.width; height: 1
                    color: Theme.baseAlt1Color
                    anchors.bottom: parent.bottom
                }

                DsLabel {
                    fontSize: Theme.h1
                    color: Theme.txtHintColor
                    text: qsTr("Checkout")
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

                    DsCheckoutPaymentMethod {
                        id: cashinput
                        label: qsTr("Cash")
                        input.placeholderText: qsTr("0.0")
                        width: parent.width - 2*Theme.baseSpacing
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    DsCheckoutPaymentMethod {
                        id: mpesainput
                        label: qsTr("M-Pesa")
                        input.placeholderText: qsTr("0.0")
                        width: parent.width - 2*Theme.baseSpacing
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    DsCheckoutPaymentMethod {
                        id: chequeinput
                        label: qsTr("Cheque")
                        mandatory: true
                        input.placeholderText: qsTr("0.0")
                        width: parent.width - 2*Theme.baseSpacing
                        anchors.horizontalCenter: parent.horizontalCenter
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
                        text: qsTr("Submit")
                        endIcon: IconType.arrowRight
                        // iconType: IconType.plus
                        onClicked: goToCheckout()
                    }
                }
            }
        }
    }

    Requests {
        id: addproductrequest
        baseUrl: "https://pb.digisto.app"
        path: "/api/collections/product/records"
        method: "POST"
    }

    function goToCheckout() {
        var barcode = "" //  barcodeinput.input.text.trim()
        var units = "" //  unitinput.input.text.trim()
        var name = "" //  nameinput.input.text.trim()
        var bp = "" //  bpinput.input.text.trim()
        var sp = "" //  spinput.input.text.trim()
        var stock = "" //  stockinput.input.text.trim()
        var thumbnail = "" //  thumbnailinput.input.text.trim()

        if(units.length===0) {
            return;
        }

        if(name.length <= 2) {
            return;
        }

        if(bp==="") bp=0
        if(sp==="") sp=0
        if(stock==="") stock=0

        var body = {
            name,
            unit: units,
            barcode,
            buying_price: bp,
            selling_price: sp,
            stock: stock,
            organization: "clhyn7tolbhy98k"
        }

        var files = {
            thumbnail
        }

        addproductrequest.clear()
        addproductrequest.body = body
        if(thumbnail!=="") addproductrequest.files = files

        var res = addproductrequest.send();
        console.log(JSON.stringify(res))

        if(res.status===200) {
            root.close()
        } else {
        }
    }

    function clearInputs() {
    }
}
