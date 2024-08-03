import QtQuick

import "../../controls"

DsPage {
    id: loginPage

    title: qsTr("Password Reset")

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
        }
    }
}
