import QtQuick
import QtQuick.Dialogs
import Qt.labs.platform
import app.digisto.modules

import "../../controls"

DsPage {
    id: loginPage
    title: qsTr("Sign Up Page")
    headerShown: false

    Item {
        width: 400
        height: col.height + 2*theme.baseSpacing
        anchors.centerIn: parent

        Column {
            id: col
            width: parent.width - 2*theme.baseSpacing
            spacing: theme.xsSpacing
            anchors.centerIn: parent

            Image {
                height: 50
                source: "qrc:/assets/imgs/logo-nobg.png"
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsLabel {
                topPadding: theme.baseSpacing
                bottomPadding: theme.smSpacing
                text: qsTr("Create Account")
                fontSize: theme.h2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsInputWithLabel {
                id: emailinput
                width: parent.width
                label: qsTr("Email")
                errorString: qsTr("Invalid Email Address")
                input.placeholderText: qsTr("user@example.com")
            }

            DsInputWithLabel {
                id: fullnameinput
                width: parent.width
                label: qsTr("Fullname")
                input.placeholderText: qsTr("John Doe")
                errorString: qsTr("Invalid user full name")
            }

            DsInputWithLabel {
                id: passwordinput
                width: parent.width
                isPasswordInput: true
                label: qsTr("Password")
                input.placeholderText: qsTr("********")
                errorString: qsTr("Empty or short password")
            }

            DsInputWithLabel {
                id: passwordconfirminput
                width: parent.width
                isPasswordInput: true
                label: qsTr("Confirm Password")
                input.placeholderText: qsTr("********")
                errorString: qsTr("Empty or short password")
            }

            Item { height: 1; width: 1}

            DsButton {
                height: theme.lgBtnHeight
                fontSize: theme.xlFontSize
                width: parent.width
                text: qsTr("Register")
                busy: createAccountRequest.running || emailVerificationRequest.running

                onClicked: createUserAccount();
            }

            // Pop this page to go back to login page
            // which is presumed to be the previous page
            DsLabel {
                fontSize: theme.smFontSize
                text: qsTr("Back to login")
                height: theme.btnHeight
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
        baseUrl: "https://pb.digisto.app"
        path: "/api/collections/tellers/records"
        method: "POST"
    }

    Requests {
        id: emailVerificationRequest
        baseUrl: "https://pb.digisto.app"
        path: "/api/collections/tellers/request-verification"
        method: "POST"
    }

    MessageDialog {
        id: warningdialog
        buttons: MessageDialog.Ok
    }

    function createUserAccount() {
        var email = emailinput.input.text.trim()
        var name = fullnameinput.input.text.trim()
        var password = passwordinput.input.text.trim()
        var passwordConfirm = passwordconfirminput.input.text.trim()

        if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)) {
            emailinput.hasError = true;
            return;
        }

        if(name.split(" ").length === 0) {
            fullnameinput.hasError=true;
            fullnameinput.errorString = qsTr("At least two names expected")
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
            name
        }

        createAccountRequest.clear()
        createAccountRequest.body = body;
        var res = createAccountRequest.send();
        console.log(JSON.stringify(res))

        if(res.status===200) {
            console.log("User created")
            switchToEmailConfirmation(res.data.email)
        } else {
            // User creation failed
            warningdialog.text = "Account Creation Failed"
            warningdialog.informativeText = res.error
            warningdialog.open()
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
}
