import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.qmlmodels
import app.digisto.modules

import "../controls"

DsDrawer {
    id: root
    width: Math.min(500, mainApp.width * 0.9)

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
                    active: hovered || pressed
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
                        label: qsTr("Full Name")
                        input.placeholderText: qsTr("Firstname Lastname")
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

    }

    function addUser() {
        var email = emailfield.input.text.trim()
        var name = namefield.input.text.trim()
        var mobileno = parseInt(mobilefield.input.text.trim()) ? parseInt(mobilefield.input.text.trim()) : 0

        if(name.split(' ')<=1 || name.length < 3) {
            namefield.hasError=true;
            namefield.errorString = qsTr("At least two names expected")
            return;
        }

        if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)) {
            emailfield.hasError = true;
            return;
        }

        if(mobilefield.selectedCountry || mobileno >= 10000000) {
            if(!mobilefield.selectedCountry) {
                showMessage(qsTr("Create Account Error"),
                            qsTr("Country code for your mobile number not selected!"))
                return;
            }

            if(mobileno < 10000000) {
                showMessage(qsTr("Create Account Error"),
                            qsTr("Mobile number is not valid!"))
                return;
            }
        }

        const body = {
            email,
            name,
            password: "12345678",
            passwordConfirm: "12345678",
            permissions: globalModels.userPermissonsTemplate,
            reset_password_on_login: true,
            is_admin: false,
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
            showMessage(
                        qsTr("Connection Refused"),
                        qsTr("Could not connect to the server, something is'nt right!")
                        )
        }

        else if(res.status === 403) {
            showMessage(
                        qsTr("Authentication Error"),
                        qsTr("You don't seem to have access rights to perform this action.")
                        )
        }

        else {
            showMessage(
                        qsTr("Error Occured"),
                        res.message ? res.message : qsTr("Yuck! Something not right here!")
                        )
        }
    }
}
