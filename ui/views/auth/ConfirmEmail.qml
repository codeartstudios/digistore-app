import QtQuick

import "../../controls"

/*
  Confirm Email Page

  Prompt users to comfirm email used in sign up, through
  a link sent over email.

  Actions:
    - Proceed to login page
*/

DsPage {
    id: loginPage
    title: qsTr("Password Reset")
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

            DsIcon {
                iconSize: Theme.lgBtnHeight
                iconType: IconType.mailQuestion
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsLabel {
                bottomPadding: Theme.smSpacing
                text: qsTr("Confirm Email")
                fontSize: Theme.h2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsLabel {
                fontSize: Theme.smFontSize
                width: parent.width * 0.8
                wrapMode: DsLabel.WordWrap
                bottomPadding: Theme.xsSpacing
                horizontalAlignment: DsLabel.AlignHCenter
                text: qsTr("Your account has been created successfully. We have sent a link to the provided email, click on it to confirm the email then proceed to login.")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item { height: 1; width: 1}

            DsButton {
                height: Theme.lgBtnHeight
                fontSize: Theme.xlFontSize
                width: parent.width
                text: qsTr("Proceed to login")

                onClicked: navigationStack.pop(null)
            }
        }
    }
}
