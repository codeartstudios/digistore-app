import QtQuick
import QtQuick.Dialogs
import Qt.labs.platform
import QtQuick.Controls.Basic
import app.digisto.modules

import "../../controls"
import "../../popups"
import "../../js/main.js" as Djs

DsPage {
    id: loginPage
    title: qsTr("Login Page")
    headerShown: false

    required property var stack

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
                mandatory: true
                label: qsTr("Email/Username")
                errorString: qsTr("Invalid email or username")
                input.placeholderText: qsTr("user@example.com")
            }

            DsInputWithLabel {
                id: passwordinput
                width: parent.width
                mandatory: true
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
                    onClicked: stack.push("qrc:/ui/views/auth/PasswordReset.qml", { stack: navigationStack })
                }
            }

            Item { height: 1; width: 1}

            DsButton {
                busy: loginrequest.running
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
                    onClicked: navigationStack.push("qrc:/ui/views/auth/CreateAccount.qml", { stack: navigationStack })
                }
            }
        }
    }

    Requests {
        id: loginrequest
        baseUrl: dsController.baseUrl
        path: "/api/collections/tellers/auth-with-password"
        method: "POST"
    }

    DsMessageBox {
        id: messageBox
        x: (loginPage.width-width)/2
        y: (loginPage.height-height)/2

        function showMessage(title="", info="") {
            messageBox.title = title
            messageBox.info = info
            messageBox.open()
        }
    }

    function signIn() {
        var identity = emailinput.input.text.trim()
        var password = passwordinput.input.text.trim()

        // TODO Accepted username chars?
        if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(identity) || identity.length < 4 ) {
            emailinput.hasError = true;
            return;
        }

        if(password.length < 4) {
            passwordinput.hasError = true;
            passwordinput.errorString = qsTr("Password is too short!")
            return;
        }

        // Create a search query
        var query = {
            expand: "organization"
        }

        var body = {
            identity,
            password
        }

        loginrequest.clear()
        loginrequest.query = query;
        loginrequest.body = body;
        var res = loginrequest.send();

        if(res.status===200) {
            // Extract response data ...
            var data = res.data
            var token = data.token
            var user = data.record
            var orgDataExists = user.hasOwnProperty('expand') &&
                    user.expand.hasOwnProperty('organization')
            var org = (user.organization==='' || !orgDataExists) ?
                        null : user.expand.organization

            dsController.token = token;
            dsController.loggedUser = user;
            dsController.organization = org ? org : {};
            dsController.workspaceId = org ? org.id : '';

            clearInputs()

            // Check if user should reset password first ...
            if(user.reset_password_on_login) {
                toast.success(qsTr("Before you go, you are required to set a new password!"))
                mandatoryResetPassword()
            }

            // Check if user is part of an organization,
            // if not so, go to create organization.
            else if(!org || !org.id || (org && org.id==='')) {
                toast.success(qsTr("We couldn't find any organization for you!"))
                mandatoryCreateOrGetOrganization()
            }

            else {
                // All checks fine, lets then check if we can log in finally!
                dsController.isLoggedIn = Djs.checkIfLoggedIn()

                // Show toast message
                toast.success(qsTr("Login Success!"))
            }
        } else {
            // console.log(JSON.stringify(res))
            // User creation failed
            messageBox.showMessage(qsTr("Login Failed"), Utils.error(res))
        }
    }

    function clearInputs() {
        emailinput.input.clear()
        passwordinput.input.clear()
    }

    function mandatoryResetPassword() {
        stack.pop()
        stack.push("qrc:/ui/views/auth/ChangePassword.qml",
                   { stack: navigationStack }, StackView.Immediate)
    }

    function mandatoryCreateOrGetOrganization() {
        stack.pop()
        stack.push("qrc:/ui/views/auth/CreateOrJoinOrganization.qml",
                   {
                       stack: navigationStack
                   }, StackView.Immediate)
    }

    // TODO REMOVE
    // Timer {
    //     id: prefillTimer
    //     interval: 500
    //     repeat: false
    //     triggeredOnStart: true
    //     onTriggered: {
    //         if(running) {
    //             emailinput.text = 'allan@digisto.app'
    //             passwordinput.text = '123123123'
    //         } else {
    //             signIn()
    //         }
    //     }
    // }

    // Component.onCompleted: {
    //     prefillTimer.restart()
    // }
}
