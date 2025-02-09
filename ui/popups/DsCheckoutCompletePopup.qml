import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.platform
import QtQuick.Controls.Basic
import app.digisto.modules

import "../controls"

Popup {
    id: root
    width: 400
    height: col.height + 2*Theme.baseSpacing
    modal: true
    x: (parent.width-width)/2
    y: (parent.height-height)/2
    closePolicy: Popup.NoAutoClose

    // Passed in Cash Amount Paid
    property real cashAmountPaid: 0

    DsCheckoutBalanceDisplayPopup {
        id: balancePopup

        onClosed: {
            completeCheckoutSession()
            root.close()
        }
    }

    background: Rectangle {
        color: Theme.bodyColor
        radius: Theme.btnRadius
    }

    contentItem: Item {
        anchors.fill: parent

        Column {
            id: col
            spacing: Theme.smSpacing
            width: parent.width - 2*Theme.baseSpacing
            anchors.centerIn: parent

            // Header Bar
            Item {
                width: parent.width
                height: Theme.btnHeight

                Rectangle {
                    width: parent.width; height: 1
                    color: Theme.baseAlt1Color
                    anchors.bottom: parent.bottom
                }

                DsLabel {
                    fontSize: Theme.h1
                    color: Theme.txtHintColor
                    text: qsTr("Complete Checkout")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                }
            } // Header Bar

            DsInputWithLabel {
                id: cashInput
                width: parent.width
                input.placeholderText: qsTr("0.0")
                label: qsTr("Cash Amount")
                validator: DoubleValidator{ bottom: cashAmountPaid }

                onTextAccepted: computeBalanceDue()
            }

            DsButton {
                anchors.right: parent.right
                text: qsTr("Submit")
                onClicked: computeBalanceDue()
            }
        }
    }

    function computeBalanceDue() {
        // Parse Cash Amount Entered
        var cash = parseFloat(cashInput.input.text.trim())

        if(cashInput.input.text.trim() === "") {
            showMessage(qsTr("Error!"), qsTr("Amount entered"))
            return;
        }

        if(cash < root.cashAmountPaid) {
            showMessage(qsTr("Error!"), qsTr("Amount Entered is less than cash paid!"))
            return;
        }

        // Calculate the user balance
        var balance = cash - root.cashAmountPaid

        // End checkout session
        completeCheckoutSession()

        // Display balance popup if > 0
        if(balance > 0) {
            balancePopup.open();
            balancePopup.balanceDue = balance;
        }

        else {
            root.close()
        }

    }

    onOpened: {
        root.cashAmountPaid = 0
        cashInput.input.clear()
        cashInput.input.forceActiveFocus()
    }

    onClosed: toast.info(qsTr("Checkout Successful!"))
}
