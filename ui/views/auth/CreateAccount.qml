import QtQuick

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
                width: parent.width
                label: qsTr("Email")
                input.placeholderText: qsTr("user@example.com")
            }

            DsInputWithLabel {
                width: parent.width
                label: qsTr("Fullname")
                input.placeholderText: qsTr("John Doe")
            }

            DsInputWithLabel {
                width: parent.width
                isPasswordInput: true
                label: qsTr("Password")
                input.placeholderText: qsTr("********")
            }

            Item { height: 1; width: 1}

            DsButton {
                height: theme.lgBtnHeight
                fontSize: theme.xlFontSize
                width: parent.width
                text: qsTr("Register")
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
}
