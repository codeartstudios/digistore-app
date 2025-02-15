import QtQuick
import QtQuick.Dialogs
import Qt.labs.platform
import QtQuick.Controls.Basic
import app.digisto.modules

import "../../controls"
import "../../popups"

DsPage {
    id: root
    title: qsTr("Onboarding Page")
    headerShown: false

    DsCard {
        width: 400
        height: col.height + 2*Theme.baseSpacing
        anchors.centerIn: parent

        Column {
            id: col
            width: parent.width - 2*Theme.baseSpacing
            spacing: Theme.xsSpacing
            anchors.centerIn: parent

            Image {
                height: 100
                source: "qrc:/assets/imgs/logo-nobg.png"
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsLabel {
                topPadding: Theme.baseSpacing
                bottomPadding: Theme.smSpacing
                text: qsTr("Digisto")
                fontSize: Theme.h2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsLabel {
                text: qsTr("Sell Faster, Manage Smarter")
                fontSize: Theme.smFontSize
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item { height: 1; width: 1}

            DsButton {
                endIcon: IconType.arrowRight
                fontSize: Theme.xlFontSize
                text: qsTr("Let's Go!")
                onClicked: goToLogin()

                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Timer {
        id: gotologinTimer
        interval: 3000
        repeat: false
        onTriggered: goToLogin()
    }

    function goToLogin() {
        gotologinTimer.stop()
        navigationStack.push("qrc:/ui/views/auth/Login.qml",
                             {
                                 stack: navigationStack
                             }, StackView.Immediate)
    }

    Component.onCompleted: gotologinTimer.restart()
}
