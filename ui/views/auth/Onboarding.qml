import QtQuick
import QtQuick.Dialogs
import Qt.labs.platform
import app.digisto.modules

import "../../controls"

DsPage {
    id: loginPage
    title: qsTr("Onboarding Page")
    headerShown: false

    Item {
        width: 400
        height: col.height + 2*Theme.baseSpacing
        anchors.centerIn: parent

        Column {
            id: col
            width: parent.width - 2*Theme.baseSpacing
            spacing: Theme.xsSpacing
            anchors.centerIn: parent

            Image {
                height: 50
                source: "qrc:/assets/imgs/logo-nobg.png"
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsLabel {
                topPadding: Theme.baseSpacing
                bottomPadding: Theme.smSpacing
                text: qsTr("User Sign in")
                fontSize: Theme.h2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsInputWithLabel {
                id: emailinput
                width: parent.width
                label: qsTr("Email/Username")
                errorString: qsTr("Invalid Email or User ID")
                input.placeholderText: qsTr("user@example.com")
            }

            DsInputWithLabel {
                id: passwordinput
                width: parent.width
                isPasswordInput: true
                label: qsTr("Password")
                input.placeholderText: qsTr("********")
                errorString: qsTr("Empty or short password")
            }

            DsLabel {
                fontSize: Theme.smFontSize
                text: qsTr("Forgot password?")

                MouseArea {
                    anchors.fill: parent
                    onClicked: navigationStack.push("qrc:/ui/views/auth/PasswordReset.qml")
                }
            }

            Item { height: 1; width: 1}

            DsButton {
                busy: signinRequest.running
                height: Theme.lgBtnHeight
                fontSize: Theme.xlFontSize
                width: parent.width
                text: qsTr("Login")
                onClicked: signIn()
            }

            // Pop this page to go back to login page
            // which is presumed to be the previous page
            DsLabel {
                fontSize: Theme.smFontSize
                text: qsTr("Sign up instead")
                height: Theme.btnHeight
                width: parent.width
                horizontalAlignment: DsLabel.AlignHCenter
                verticalAlignment: DsLabel.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: navigationStack.push("qrc:/ui/views/auth/CreateAccount.qml")
                }
            }
        }
    }

    Requests {
        id: signinRequest
        baseUrl: "https://pbs.digisto.app"
        path: "/api/collections/tellers/auth-with-password"
        method: "POST"
    }

    MessageDialog {
        id: warningdialog
        buttons: MessageDialog.Ok
    }

    function signIn() {
        var identity = emailinput.input.text.trim()
        var password = passwordinput.input.text.trim()

        if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(identity) || identity.length > 4 ) {
            emailinput.hasError = true;
            return;
        }

        if(password.length < 4) {
            passwordinput.hasError = true;
            passwordinput.errorString = qsTr("Password is too short!")
            return;
        }

        var body = {
            identity,
            password
        }

        request.clear()
        request.body = body;
        var res = request.send();
        console.log(JSON.stringify(res))

        if(res.status===200) {
            console.log("User logged in")
            // Confirm email

        } else {
            // User creation failed
            warningdialog.text = "Login Failed"
            warningdialog.informativeText = res.error
            warningdialog.open()
        }
    }
}
