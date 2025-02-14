import QtQuick
import QtQuick.Dialogs
import Qt.labs.platform
import QtQuick.Layouts
import app.digisto.modules

import "../../controls"
import "../../popups"

DsPage {
    id: root
    title: qsTr("Sign Up Page")
    headerShown: false

    required property var stack

    DsCard {
        width: 400
        height: col.height + 2*Theme.baseSpacing
        anchors.centerIn: parent

        Column {
            id: col
            width: parent.width - 2*Theme.baseSpacing
            spacing: Theme.xsSpacing
            anchors.centerIn: parent

            DsLabel {
                topPadding: Theme.baseSpacing
                bottomPadding: Theme.smSpacing
                text: qsTr("Create or Join Organization")
                fontSize: Theme.h2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsLabel {
                fontSize: Theme.smFontSize
                text: qsTr('Select an option below, whether creating a new organization or joining an existing one.')
                color: Theme.txtHintColor
                width: parent.width
                wrapMode: DsLabel.WordWrap
                horizontalAlignment: DsLabel.AlignHCenter
            }

            Rectangle {
                id: orgModeSelection
                width: parent.width
                height: Theme.lgBtnHeight
                radius: Theme.btnRadius
                color: Theme.shadowColor

                property bool isCreatingNewOrg: false

                Rectangle {
                    width: (parent.width - Theme.btnRadius*2)/2
                    height: Theme.btnHeight
                    radius: Theme.btnRadius
                    color: Theme.primaryColor
                    x: !parent.isCreatingNewOrg ? Theme.btnRadius :
                                                  (parent.width - Theme.btnRadius*2)/2 + Theme.btnRadius
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on x { NumberAnimation { easing.type: Easing.InOutQuad }}
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.btnRadius

                    DsLabel {
                        isBold: !orgModeSelection.isCreatingNewOrg
                        fontSize: Theme.smFontSize
                        text: qsTr('Join Existing Org.')
                        color: !orgModeSelection.isCreatingNewOrg ?
                                   Theme.baseColor : Theme.txtHintColor
                        elide: DsLabel.ElideRight
                        horizontalAlignment: DsLabel.AlignHCenter
                        verticalAlignment: DsLabel.AlignVCenter
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        DsMouseArea {
                            anchors.fill: parent
                            onClicked: orgModeSelection.isCreatingNewOrg=false
                        }
                    }

                    DsLabel {
                        isBold: orgModeSelection.isCreatingNewOrg
                        fontSize: Theme.smFontSize
                        text: qsTr('Create New Org.')
                        color: orgModeSelection.isCreatingNewOrg ?
                                   Theme.baseColor : Theme.txtHintColor
                        elide: DsLabel.ElideRight
                        horizontalAlignment: DsLabel.AlignHCenter
                        verticalAlignment: DsLabel.AlignVCenter
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        DsMouseArea {
                            anchors.fill: parent
                            onClicked: orgModeSelection.isCreatingNewOrg=true
                        }
                    }
                }
            }

            DsInputWithLabel {
                id: orgnameInput
                visible: orgModeSelection.isCreatingNewOrg
                width: parent.width
                label: qsTr("Org. Name")
                mandatory: true
                errorString: qsTr("Short organization name")
                input.placeholderText: qsTr("My Org Name")
            }

            DsInputWithLabel {
                id: workspaceInput
                visible: orgModeSelection.isCreatingNewOrg
                width: parent.width
                mandatory: true
                label: qsTr("Unique Workspace ID")
                errorString: qsTr("Workspace URL is empty!")
                input.placeholderText: qsTr("my-org")
                secondaryActionLabel.text: qsTr("clear")
                secondaryActionLabel.color: Theme.dangerColor
                onSecondaryAction: workspaceinput.text = ""

                beforeItem: DsLabel {
                    text: qsTr("https://digisto.app/co/")
                    fontSize: Theme.smFontSize
                    color: Theme.txtHintColor
                }
            }

            DsLabel {
                visible: !orgModeSelection.isCreatingNewOrg
                fontSize: Theme.smFontSize
                text: qsTr('Nothing to be done here, contact the organization Admin to be invited into the organization.')
                color: Theme.txtHintColor
                width: parent.width
                wrapMode: DsLabel.WordWrap
                horizontalAlignment: DsLabel.AlignHCenter
            }

            Item { height: 1; width: 1}

            DsButton {
                height: Theme.lgBtnHeight
                fontSize: Theme.xlFontSize
                width: parent.width
                text: orgModeSelection.isCreatingNewOrg ? qsTr("Create Org.") : qsTr('Okay')
                busy: createOrgRequest.running

                onClicked: orgModeSelection.isCreatingNewOrg ?
                               createNewOrganization() : toast.info(qstr('...'));
            }
        }
    }

    Requests {
        id: createOrgRequest
        method: "POST"
        token: dsController.token
        baseUrl: dsController.baseUrl
        path: "/api/collections/organization/records"
    }

    function createNewOrganization() {
        var name = orgnameInput.input.text.trim()
        var workspace = workspaceInput.input.text.trim()

        if(name.length < 3) {
            orgnameInput.hasError=true;
            orgnameInput.errorString = qsTr("Organization name is required!")
            return;
        }

        if(name.length < 3) {
            workspaceInput.hasError=true;
            workspaceInput.errorString = qsTr("Workspace ID is required!")
            return;
        }

        var body = {
            name,
            workspace,
            approved: true
        }

        createOrgRequest.clear()
        createOrgRequest.body = body;
        var res = createOrgRequest.send();
        console.log(JSON.stringify(res))

        if(res.status===200) {
            // clearInputs()
            // switchToEmailConfirmation(email)
            // console.log("Account Created")
            // navigationStack.pop()
        } else {
            // User creation failed
            messageBox.showMessage(qsTr("Create Account Error"),
                                   res.data.message
                                   )

        }
    }

    function clearInputs() {
        orgnameInput.input.clear()
        workspaceInput.input.clear()
    }
}
