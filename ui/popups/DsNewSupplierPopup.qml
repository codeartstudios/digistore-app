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
    x: (mainApp.width-width)/2
    y: (mainApp.height-height)/2
    closePolicy: Popup.NoAutoClose

    QtObject {
        id: internal
        property bool canAddSuppliers: dsController.loggedUser.is_admin ||
                                       dsController.loggedUser.permissions.can_add_suppliers ||
                                       dsController.loggedUser.permissions.can_manage_suppliers
    }

    onOpened: {
        clearInputs()
        nameinput.input.forceActiveFocus()
    }

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
                    text: qsTr("New Supplier")
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

                    DsInputWithLabel {
                        id: nameinput
                        label: qsTr("Supplier Name")
                        mandatory: true
                        input.placeholderText: qsTr("i.e. Blue Pen")
                        width: parent.width - 2*Theme.baseSpacing
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Row {
                        spacing: Theme.smSpacing
                        width: parent.width - 2*Theme.baseSpacing
                        anchors.horizontalCenter: parent.horizontalCenter

                        DsInputWithLabel {
                            id: emailinput
                            label: qsTr("Email")
                            input.placeholderText: qsTr("i.e. user@email.com")
                            width: (parent.width-parent.spacing)/2
                        }

                        DsInputMobileNumber {
                            id: mobileinput
                            label: qsTr("Mobile")
                            input.placeholderText: qsTr("i.e. 07xx xxx xxx")
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
                        enabled: internal.canAddSuppliers
                        busy: addproductrequest.running
                        text: qsTr("Submit")
                        iconType: IconType.playlistAdd
                        onClicked: addSupplier()
                    }
                }
            }
        }
    }

    Requests {
        id: addproductrequest
        path: "/api/collections/suppliers/records"
        baseUrl: dsController.baseUrl
        token: dsController.token
        method: "POST"
    }

    function addSupplier() {
        // Check for permissions before proceeding ...
        if(!internal.canAddSuppliers) {
            showMessage(qsTr("Yuck!"),
                        qsTr("Seems you don't have access to this feature, check with your admin!"))
            return;
        }

        var name = nameinput.input.text.trim()
        var email = emailinput.input.text.trim()
        var mobile = null

        if(name.length <= 2) {
            showMessage(qsTr("Supplier Error!"), qsTr("Supplier name is required, must be more than 4 characters long!"))
            return;
        }

        // TODO parse correct mobile number & email
        if(!mobileinput.selectedCountry && mobileinput.text.trim() !== "") {

            showMessage(qsTr("Supplier Error!"),
                        qsTr("Select country code for the mobile number."))
            return;
        }

        if(mobileinput.selectedCountry && parseInt(mobileinput.input.text.trim()) < 10000000) {
            showMessage(qsTr("Supplier Error!"),
                        qsTr("Mobile number is not valid!"))
            return;
        }

        if(mobileinput.selectedCountry && parseInt(mobileinput.input.text.trim()) >= 10000000) {
            console.log("Yaay!")
            mobile = {
                dial_code: mobileinput.selectedCountry.dial_code,
                number: parseInt(mobileinput.input.text.trim())
            }
        }

        if(email !== "" && !/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)) {
            showMessage(qsTr("Supplier Error!"),
                        qsTr("The format of the email provided is not right."))
            return;
        }

        var body = {
            name,
            email,
            organization: dsController.workspaceId
        }

        if(mobile) body["mobile"] = mobile

        addproductrequest.clear()
        addproductrequest.body = body
        var res = addproductrequest.send();
        // console.log(JSON.stringify(res))

        if(res.status===200) {
            root.close()
            // TODO add message toast ...
        } else {
            showMessage(qsTr("Supplier Error!"), qsTr("Error creating new supplier, error ")+res.status.toString())
        }
    }

    function clearInputs() {
        nameinput.input.text=""
        emailinput.input.text=""
        mobileinput.input.text=""
        mobileinput.clear()
    }
}
