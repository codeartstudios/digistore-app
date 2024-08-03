import QtQuick

import "../../controls"

/*
  PasswordReset Page

  Allow users to reset their passwords, this should trigger
  the send reset link via email. The page requires that the user
  is registered, and consequently, the provided email is already
  associated with their account.

  Note: popping the stack should** go back to the login page (
  previos page)
*/

DsPage {
    id: loginPage
    title: qsTr("Password Reset")
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
                text: qsTr("Forgotten Password")
                fontSize: theme.h2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsLabel {
                fontSize: theme.smFontSize
                width: parent.width * 0.8
                wrapMode: DsLabel.WordWrap
                bottomPadding: theme.xsSpacing
                horizontalAlignment: DsLabel.AlignHCenter
                text: qsTr("Enter email associated with your account. We will send you a reset link.")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsInputWithLabel {
                width: parent.width
                label: qsTr("Email")
                input.placeholderText: qsTr("user@example.com")
            }

            Item { height: 1; width: 1}

            DsButton {
                height: theme.lgBtnHeight
                fontSize: theme.xlFontSize
                width: parent.width
                iconType: dsIconType.mailForward
                text: qsTr("Send recovery link")
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
