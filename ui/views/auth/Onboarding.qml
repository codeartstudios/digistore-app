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
                text: (dsController.organization &&
                       dsController.organization.name &&
                       workspaceinput.text===dsController.organization.name) ?
                          qsTr("Welcome back to") + ` ${dsController.organization.name}` :
                          qsTr("Let's get your organization details.")
                fontSize: Theme.smFontSize
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsInputWithLabel {
                id: workspaceinput
                width: parent.width
                text: (dsController.organization &&
                       dsController.organization.workspace) ?
                          dsController.organization.workspace : ""
                label: qsTr("Workspace")
                errorString: qsTr("Workspace URL is doesn't exist!")
                input.placeholderText: qsTr("workspace")
                secondaryActionLabel.text: qsTr("change")
                secondaryActionLabel.color: Theme.dangerColor
                onSecondaryAction: workspaceinput.text = ""
                readOnly: (dsController.organization &&
                           dsController.organization.workspace) ? true : false

                beforeItem: DsLabel {
                    text: qsTr("https://")
                    fontSize: Theme.lgFontSize
                    color: Theme.txtHintColor
                }

                afterItem: DsLabel {
                    text: qsTr(".digisto.app")
                    fontSize: Theme.lgFontSize
                    color: Theme.txtHintColor
                }
            }

            Item { height: 1; width: 1}

            DsButton {
                busy: workspacerequest.running
                height: Theme.lgBtnHeight
                fontSize: Theme.xlFontSize
                width: parent.width
                text: qsTr("Next")
                onClicked: checkWorkspaceRequest()
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
                    onClicked: navigationStack.push(
                                   "qrc:/ui/views/auth/CreateAccount.qml", { stack: navigationStack },
                                   StackView.Immediate
                                   )
                }
            }
        }
    }

    Requests {
        id: workspacerequest
        baseUrl: dsController.baseUrl
        path: "/api/collections/organization_view/records"
    }

    function checkWorkspaceRequest() {
        var workspace = workspaceinput.input.text.trim();

        // We have cached org login information, no need anymore.
        if(dsController.organization &&
                dsController.organization.workspace &&
                dsController.organization.workspace===workspace) {

            // console.log("Using cached organization details: ",
            // JSON.stringify(dsController.organization))

            clearInputs();
            navigationStack.push("qrc:/ui/views/auth/Login.qml",
                                 {
                                     stack: navigationStack,
                                     organization: dsController.organization
                                 }, StackView.Immediate)
        }

        else {
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
                filter: `workspace='${workspace}'`
            }

            // Prepare and send request
            workspacerequest.clear()
            workspacerequest.query = query;
            var res = workspacerequest.send();

            if(res.status===200) {
                var orgs = res.data.items
                if(orgs.length===0) {
                    messageBox.showMessage(qsTr("Org Workspace Error"),
                                           qsTr("We didn't find a workspace matching your input!"))
                } else {
                    var org = orgs[0]
                    clearInputs()
                    dsController.organization = org;
                    navigationStack.push("qrc:/ui/views/auth/Login.qml",
                                         {
                                             stack: navigationStack,
                                             organization: org
                                         }, StackView.Immediate)
                }
            }

            else {
                messageBox.showMessage(
                            qsTr("Org Workspace Error"),
                            res.data.message
                            )
            }
        }
    }

    DsMessageBox {
        id: messageBox
        x: (root.width-width)/2
        y: (root.height-height)/2

        function showMessage(title="", info="") {
            messageBox.title = title
            messageBox.info = info
            messageBox.open()
        }
    }

    function clearInputs() {
        workspaceinput.text = "";
    }
}
