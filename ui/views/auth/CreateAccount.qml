import QtQuick
import QtQuick.Dialogs
import Qt.labs.platform
import app.digisto.modules

import "../../controls"
import "../../popups"

DsPage {
    id: root
    title: qsTr("Sign Up Page")
    headerShown: false

    required property  var stack

    DsCard {
        width: 400
        height: col.height + 2*Theme.baseSpacing
        anchors.centerIn: parent

        Column {
            id: col
            width: parent.width - 2*Theme.baseSpacing
            spacing: Theme.xsSpacing
            anchors.centerIn: parent

            DsLabel {
                topPadding: Theme.baseSpacing
                bottomPadding: Theme.smSpacing
                text: qsTr("Create Account")
                fontSize: Theme.h2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsInputWithLabel {
                id: emailinput
                width: parent.width
                label: qsTr("Email")
                mandatory: true
                errorString: qsTr("Invalid Email Address")
                input.placeholderText: qsTr("user@example.com")
            }

            DsInputWithLabel {
                id: fullnameinput
                width: parent.width
                label: qsTr("Fullname")
                mandatory: true
                input.placeholderText: qsTr("John Doe")
                errorString: qsTr("Invalid user full name")
            }

            DsInputMobileNumber {
                id: mobileinput
                width: parent.width
                label: qsTr("Mobile Number")
                mandatory: true
                validator: IntValidator{bottom: 1000000}
                input.placeholderText: qsTr("7xx xxx xxx")
                errorString: qsTr("Invalid mobile number")
            }

            Row {
                spacing: Theme.xsSpacing
                width: parent.width

                DsInputWithLabel {
                    id: passwordinput
                    width: (parent.width-Theme.xsSpacing)/2
                    mandatory: true
                    isPasswordInput: true
                    label: qsTr("Password")
                    input.placeholderText: qsTr("********")
                    errorString: qsTr("Empty or short password")
                }

                DsInputWithLabel {
                    id: passwordconfirminput
                    width: (parent.width-Theme.xsSpacing)/2
                    mandatory: true
                    isPasswordInput: true
                    label: qsTr("Confirm Password")
                    input.placeholderText: qsTr("********")
                    errorString: qsTr("Empty or short password")
                }
            }

            Item { height: 1; width: 1}

            DsButton {
                height: Theme.lgBtnHeight
                fontSize: Theme.xlFontSize
                width: parent.width
                text: qsTr("Register")
                busy: createAccountRequest.running || emailVerificationRequest.running

                onClicked: createUserAccount();
            }

            // Pop this page to go back to login page
            // which is presumed to be the previous page
            DsLabel {
                fontSize: Theme.smFontSize
                text: qsTr("Back to login")
                height: Theme.btnHeight
                width: parent.width
                horizontalAlignment: DsLabel.AlignHCenter
                verticalAlignment: DsLabel.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: navigationStack.pop()
                }
            }
        }
    }

    Requests {
        id: createAccountRequest
        method: "POST"
        baseUrl: dsController.baseUrl
        path: "/api/collections/tellers/records"
    }

    Requests {
        id: emailVerificationRequest
        method: "POST"
        path: "/api/collections/tellers/request-verification"
        baseUrl: dsController.baseUrl
    }

    function createUserAccount() {
        var email = emailinput.input.text.trim()
        var name = fullnameinput.input.text.trim()
        var mobileno = parseInt(mobileinput.input.text.trim()) ? parseInt(mobileinput.input.text.trim()) : 0
        var password = passwordinput.input.text.trim()
        var passwordConfirm = passwordconfirminput.input.text.trim()

        if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)) {
            emailinput.hasError = true;
            return;
        }

        if(name.length < 3) {
            fullnameinput.hasError=true;
            fullnameinput.errorString = qsTr("At least two names expected")
            return;
        }

        if(!mobileinput.selectedCountry) {
            showMessage(qsTr("Create Account Error"),
                                   qsTr("Country code for your mobile number not selected!"))
            return;
        }

        if(mobileno < 10000000) {
            showMessage(qsTr("Create Account Error"),
                                   qsTr("Mobile number is not valid!"))
            return;
        }

        if(password.length < 4) {
            passwordinput.hasError=true;
            passwordinput.errorString = qsTr("Password is too short!")
            return;
        }

        if(password !== passwordConfirm) {
            passwordconfirminput.hasError=true;
            passwordconfirminput.errorString = qsTr("Passwords do not match!")
            return;
        }

        var body = {
            email,
            password,
            passwordConfirm,
            name,
            permissions: mainApp.globalModels.userPermissonsTemplate,
            mobile: {
                dial_code: mobileinput.selectedCountry.dial_code,
                number: `${mobileno}`
            }
        }

        createAccountRequest.clear()
        createAccountRequest.body = body;
        var res = createAccountRequest.send();

        if(res.status===200) {
            navigationStack.pop()
            toast.info(qsTr("Account created, let's now login."))
        } else {
            // User creation failed
            showMessage(qsTr("Create Account Error"),
                                   res.data.message
                                   )

        }
    }

    function switchToEmailConfirmation(email) {
        var body = {
            email
        }

        emailVerificationRequest.clear()
        emailVerificationRequest.body = body;
        var res = emailVerificationRequest.send();
        console.log(JSON.stringify(res))

        navigationStack.pop(null)
        navigationStack.push("qrc:/ui/views/auth/ConfirmEmail.qml")
    }

    function clearInputs() {
        emailinput.text = ""
        fullnameinput.text = ""
        mobileinput.selectedCountry = null
        mobileinput.text = ""
        passwordinput.text = ""
        passwordconfirminput.text = ""
    }
}
