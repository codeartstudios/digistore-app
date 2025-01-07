import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.platform
import app.digisto.modules

import "../controls"

Popup {
    id: root
    width: 700
    height: 400
    modal: true
    x: (parent.width-width)/2
    y: (parent.height-height)/2
    closePolicy: Popup.NoAutoClose

    property var selectedSupplier: null

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

            ScrollView {
                id: scrollview
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing

                Column {
                    width: scrollview.width
                    spacing: Theme.smSpacing

                    DsInputSelectorWithSearch {
                        label: qsTr("Select Supplier")
                        allowMultipleSelection: false
                        width: scrollview.width
                        displayFields: ["name"]
                        collection: "suppliers"
                        searchInput.placeholderText: qsTr("Search the supplier by name ...")
                    }

                    Row {
                        spacing: Theme.smSpacing
                        width: scrollview.width
                        anchors.horizontalCenter: parent.horizontalCenter

                        DsInputWithLabel {
                            id: amountinput
                            mandatory: true
                            label: qsTr("Total Cost")
                            input.placeholderText: qsTr("0.0")
                            width: (parent.width-parent.spacing)/2
                        }

                        DsInputWithLabel {
                            id: fileinput
                            label: qsTr("Supporting Docs")
                            input.placeholderText: qsTr(".pdf, .png, .jpg, .jpeg")
                            width: (parent.width-parent.spacing)/2
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
                        onClicked: addSupplier()
                    }
                }
            }
        }
    }

    Requests {
        id: addproductrequest
        path: "/api/collections/suppliers/records"
        method: "POST"
    }

    function addSupplier() {
        var name = nameinput.input.text.trim()
        var email = emailinput.input.text.trim()
        var mobile = mobileinput.input.text.trim()

        if(name.length <= 2) {
            showMessage(qsTr("Supplier Error!"), qsTr("Supplier name is required, must be more than 4 characters long!"))
            return;
        }

        // TODO parse correct mobile number & email

        var body = {
            name,
            email,
            mobile,
            organization: dsController.organizationID
        }

        addproductrequest.clear()
        addproductrequest.body = body
        var res = addproductrequest.send();
        console.log(JSON.stringify(res))

        if(res.status===200) {
            root.close()
        } else {
            showMessage(qsTr("Supplier Error!"), qsTr("Error creating new supplier, error ")+res.status.toString())
        }
    }

    function clearInputs() {
        //nameinput.input.text=""
        //emailinput.input.text=""
        //mobileinput.input.text=""
    }
}
