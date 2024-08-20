import QtQuick
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
                // validator: RegularExpressionValidator { regularExpression: /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/ }
                input.placeholderText: qsTr("user@example.com")
            }

            DsInputWithLabel {
                id: fullnameinput
                width: parent.width
                label: qsTr("Fullname")
                input.placeholderText: qsTr("John Doe")
                // validator: RegularExpressionValidator { regularExpression: /[A-F]+/ }
            }

            DsInputWithLabel {
                id: passwordinput
                width: parent.width
                isPasswordInput: true
                label: qsTr("Password")
                input.placeholderText: qsTr("********")
            }

            DsInputWithLabel {
                id: passwordconfirminput
                width: parent.width
                isPasswordInput: true
                label: qsTr("Confirm Password")
                input.placeholderText: qsTr("********")
            }

            Item { height: 1; width: 1}

            DsButton {
                height: theme.lgBtnHeight
                fontSize: theme.xlFontSize
                width: parent.width
                text: qsTr("Register")
                busy: request.running

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

    // navigationStack.pop(null)
    // navigationStack.push("qrc:/ui/views/auth/ConfirmEmail.qml")
    Requests {
        id: request
        baseUrl: "https://pb.digisto.app"
        path: "/api/collections/tellers/records"
        method: "POST"
    }

    function createUserAccount() {
        var email = emailinput.input.text
        var name = fullnameinput.input.text
        var password = passwordinput.input.text
        var passwordConfirm = passwordconfirminput.input.text

        var body = {
            email,
            password,
            passwordConfirm,
            name
        }

        request.clear()
        request.body = body;
        var res = request.send();
        console.log(JSON.stringify(res))

        if(res.status===200) {
            console.log("User created")
        } else {
            // User creation failed
        }
    }
}
