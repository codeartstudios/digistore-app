import QtQuick

import "../../controls"

DsPage {
    id: loginPage

    title: qsTr("Login Page")

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
                text: qsTr("User Sign in")
                fontSize: theme.h2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsInputWithLabel {
                width: parent.width
                label: qsTr("Username")
                input.placeholderText: qsTr("user@example.com")
            }

            DsInputWithLabel {
                width: parent.width
                isPasswordInput: true
                label: qsTr("Password")
                input.placeholderText: qsTr("********")
            }

            DsLabel {
                fontSize: theme.smFontSize
                text: qsTr("Forgot password?")

                MouseArea {
                    anchors.fill: parent
                    onClicked: navigationStack.push("qrc:/ui/views/auth/PasswordReset.qml")
                }
            }

            Item { height: 1; width: 1}

            DsButton {
                height: theme.lgBtnHeight
                fontSize: theme.xlFontSize
                width: parent.width
                text: qsTr("Login")
            }
        }
    }
}
