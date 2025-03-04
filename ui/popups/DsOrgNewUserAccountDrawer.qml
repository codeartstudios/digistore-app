import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.qmlmodels
import app.digisto.modules

import "../controls"

DsDrawer {
    id: root
    width: Math.min(500, mainApp.width * 0.9)

    DsToast{
        id: toast
        x: (parent.width - width)/2
        width: 300
    }

    signal userAdded()

    contentItem: Item {
        anchors.fill: parent

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
                    text: qsTr("Create New Account")
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                }

                Item {
                    Layout.fillWidth: true
                    height: 1
                }
            }

            DsLabel {
                color: Theme.txtPrimaryColor
                fontSize: Theme.h3
                text: qsTr("Account Details")
                topPadding: Theme.xsSpacing

                Layout.fillWidth: true
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
            }

            ScrollView {
                id: scrollview
                Layout.fillWidth: true
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.bottomMargin: Theme.baseSpacing
                Layout.fillHeight: true

                Keys.onUpPressed: scrollBar.decrease()
                Keys.onDownPressed: scrollBar.increase()

                ScrollBar.vertical: ScrollBar{
                    id: scrollBar
                    hoverEnabled: true
                    anchors.left: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                }

                Column {
                    id: col
                    width: scrollview.width
                    spacing: Theme.xsSpacing

                    DsInputWithLabel {
                        id: namefield
                        mandatory: true
                        width: col.width
                        label: qsTr("Fullname")
                        input.placeholderText: qsTr("John Doe")
                    }

                    DsInputWithLabel {
                        id: emailfield
                        mandatory: true
                        width: col.width
                        label: qsTr("Email")
                        input.placeholderText: qsTr("email@user.com")
                    }

                    DsInputMobileNumber{
                        id: mobilefield
                        mandatory: true
                        width: col.width
                        label: qsTr("Mobile Number")
                        input.placeholderText: qsTr('70012456')
                    }

                    DsComboInputWithLabel {
                        id: rolefield
                        mandatory: true
                        width: col.width
                        label: qsTr("User Role")
                        model: [
                            {id: 'admin', label: qsTr('Admin')},
                            {id: 'cashier', label: qsTr('Cashier')},
                            {id: 'manager', label: qsTr('General Manager')},
                            {id: 'stock_manager', label: qsTr('Stock Manager')}
                        ]
                        placeholderText: qsTr("No role selected")
                    }

                    DsButton {
                        width: col.width
                        busy: request.running
                        enabled: !request.running
                        text: qsTr("Create Account")
                        bgColor: Theme.successColor
                        textColor: Theme.baseColor
                        Layout.alignment: Qt.AlignVCenter

                        onClicked: addUser()
                    }
                }
            }
        }
    }

    Requests {
        id: request
        method: "POST"
        token: dsController.token
        baseUrl: dsController.baseUrl
        path: "/api/collections/tellers/records"
    }

    onOpened: clearFields()

    onClosed: {
        clearFields()
    }

    function clearFields() {
        emailfield.input.text=''
        namefield.input.text=''
        mobilefield.input.text=''
        mobilefield.selectedCountry=null
        rolefield.clear()
    }

    function addUser() {
        var email = emailfield.input.text.trim()
        var name = namefield.input.text.trim()
        var mobileno = parseInt(mobilefield.input.text.trim()) ? parseInt(mobilefield.input.text.trim()) : 0

        if(name.split(' ')<=1 || name.length < 3) {
            toast.warning(qsTr("At least two names required!"))
            return;
        }

        if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)) {
            toast.warning(qsTr("User email is not valid!"))
            return;
        }

        if(mobilefield.selectedCountry || mobileno >= 10000000) {
            if(!mobilefield.selectedCountry) {
                toast.warning(qsTr("Country code for your mobile number not selected!"))
                return;
            }

            if(mobileno < 10000000) {
                toast.warning(qsTr("Mobile number is not valid!"))
                return;
            }
        }

        if (rolefield.currentIndex < 0 || rolefield.currentIndex > rolefield.model.length ) {
            toast.warning(qsTr("User role is required, can't be empty!"))
            return;
        }

        const body = {
            email,
            name,
            password: "12345678",
            passwordConfirm: "12345678",
            role: rolefield.model[rolefield.currentIndex].id,
            reset_password_on_login: true,
            organization: dsController.workspaceId,
            mobile: {
                dial_code: mobilefield.selectedCountry.dial_code,
                number: mobileno
            }
        };

        // Reset Request Data
        request.clear()
        request.body = body
        var res = request.send();

        if(res.status===200) {
            root.close()
            root.userAdded()
            toast.success("New user created!")
        }

        else if(res.status === 0) {
            toast.error("Could not connect to the server, something is'nt right!")
        }

        else if(res.status === 400) {
            if(res.data && res.data.data) {
                var obj = res.data.data
                var keys = Object.keys(obj)

                if(keys.includes('name')) {
                    toast.error(`Name: ${obj.name.message}`)
                }

                else if(keys.includes('email')) {
                    toast.error(`Email: ${obj.email.message}`)
                }

                else if(keys.includes('mobile')) {
                    toast.error(`Mobile: ${obj.mobile.message}`)
                }

                else {
                    toast.error(Utils.error(res))
                }
            }

            else {
                toast.error(Utils.error(res))
            }
        }

        else {
            toast.error(Utils.error(res))
        }
    }
}
