import QtQuick
import QtQuick.Dialogs
import Qt.labs.platform
import app.digisto.modules

import "../../controls"

DsPage {
    id: loginPage
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
                height: 50
                source: "qrc:/assets/imgs/logo-nobg.png"
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsLabel {
                topPadding: Theme.baseSpacing
                bottomPadding: Theme.smSpacing
                text: qsTr("Onboarding Page")
                fontSize: Theme.h2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsLabel {
                topPadding: Theme.baseSpacing
                bottomPadding: Theme.smSpacing
                text: qsTr("Welcome back! Let's get your organization details.")
                fontSize: Theme.smFontSize
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsInputWithLabel {
                id: workspaceinput
                width: parent.width
                label: qsTr("Workspace")
                errorString: qsTr("Workspace URL is doesn't exist!")
                input.placeholderText: qsTr("org.digisto.app")
            }

            Item { height: 1; width: 1}

            DsButton {
                busy: workspacerequest.running
                height: Theme.lgBtnHeight
                fontSize: Theme.xlFontSize
                width: parent.width
                text: qsTr("Next")
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
        id: workspacerequest
        path: "/api/collections/organization_view/records"
        method: "GET"
    }

    MessageDialog {
        id: warningdialog
        buttons: MessageDialog.Ok
    }

    function signIn() {
        var workspace = workspaceinput.input.text.trim()

        if(workspace.length < 4) {
            workspaceinput.hasError = true;
            workspaceinput.errorString = qsTr("Workspace ID is invalid!")
            return;
        }

        // Create a search query
        var query = {
            page: 1,
            perPage: 1,
            skipTotal: true,
            filter: `workspace='${dsController.organizationID}'`
        }

        console.log(JSON.stringify(query))

        request.clear()
        request.body = body;
        var res = request.send();
        console.log(JSON.stringify(res))

        if(res.status===200) {
            console.log("Organization fetch successful")
            // Confirm email

        } else {
            // User creation failed
            warningdialog.text = "Login Failed"
            warningdialog.informativeText = res.error
            warningdialog.open()
        }
    }
}
