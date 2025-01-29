import QtQuick
import QtQuick.Dialogs
import Qt.labs.platform
import QtQuick.Controls.Basic
import app.digisto.modules

import "../../controls"
import "../../popups"

DsPage {
    id: loginPage
    title: qsTr("Login Page")
    headerShown: false

    required property var organization

    // Component.onCompleted: console.log(organization, JSON.stringify(organization))

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
                errorString: qsTr("Invalid email or username")
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
                    onClicked: navigationStack.push("qrc:/ui/views/auth/CreateAccount.qml")
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
        // console.log(JSON.stringify(res))

        if(res.status===200) {
            // console.log("User logged in")
            // Confirm email
            console.log(JSON.stringify(res))
            var token = res.data.token
            var user = res.data.record
            var org = res.data.record.expand.organization
            user.organization = org.id;

            // dsController.organization = org
            dsController.token = token;
            dsController.loggedUser = user;
            dsController.organization = org;
            dsController.workspaceId = org.id;

            console.log("\nToken: ", dsController.token)
            console.log("User: ", JSON.stringify(dsController.loggedUser))
            console.log("Org: ", JSON.stringify(dsController.organization))

            clearInputs()
            store.userLoggedIn = checkIfLoggedIn()

        } else {
            console.log(JSON.stringify(res))
            // User creation failed
            messageBox.showMessage(
                        qsTr("Login Failed"),
                        res.data.message ?
                            res.data.message : res.error ?
                                res.error : qsTr("We couldn't complete this request, please try again later.")
                        )
        }
    }

    function clearInputs() {

    }
}
