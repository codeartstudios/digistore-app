import QtQuick
import QtQuick.Dialogs
import Qt.labs.platform
import QtQuick.Controls.Basic
import app.digisto.modules

import "../../controls"
import "../../popups"

DsPage {
    id: loginPage
    title: qsTr("Changed Password Page")
    headerShown: false

    required property var stack

    Item {
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
                text: qsTr("Let's set a new password for you!")
                fontSize: Theme.h2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsInputWithLabel {
                id: oldpasswordInput
                width: parent.width
                isPasswordInput: true
                mandatory: true
                label: qsTr("Old Password")
                input.placeholderText: qsTr("********")
                errorString: qsTr("Empty or short password")
            }

            DsInputWithLabel {
                id: newpasswordInput
                width: parent.width
                isPasswordInput: true
                mandatory: true
                label: qsTr("New Password")
                input.placeholderText: qsTr("********")
                errorString: qsTr("Empty or short password")
            }

            DsInputWithLabel {
                id: cnewpasswordInput
                width: parent.width
                isPasswordInput: true
                mandatory: true
                label: qsTr("Confirm New Password")
                input.placeholderText: qsTr("********")
                errorString: qsTr("Empty or short password")
            }

            Item { height: 1; width: 1}

            DsButton {
                busy: changepasswordRequest.running
                height: Theme.lgBtnHeight
                fontSize: Theme.xlFontSize
                width: parent.width
                text: qsTr("Change Password")
                onClicked: changePassword()
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
        id: changepasswordRequest
        baseUrl: dsController.baseUrl
        token: dsController.token
        method: "PATCH"
    }

    function changePassword() {
        var oldpassword = oldpasswordInput.input.text.trim()
        var newpassword = newpasswordInput.input.text.trim()
        var cnewpassword = cnewpasswordInput.input.text.trim()

        if(oldpassword<=4) {
            oldpasswordInput.hasError = true;
            oldpasswordInput.errorString = qsTr("Old password is too short!")
            return;
        }

        if(newpassword.length <= 4) {
            newpasswordInput.hasError = true;
            newpasswordInput.errorString = qsTr("New password is too short!")
            return;
        }

        if(newpassword !== cnewpassword) {
            toast.warning(qsTr("New passwords do not match!"))
            return;
        }

        if(newpassword === oldpassword) {
            toast.error(qsTr("Old password cannot be set as a new password!"))
            return;
        }

        var body = {
            password:                   newpassword,
            passwordConfirm:            cnewpassword,
            oldPassword:                oldpassword,
            name:                       dsController.loggedUser.name,
            permissions:                dsController.loggedUser.permissions,
            mobile:                     dsController.loggedUser.mobile,
            reset_password_on_login:    false,
        }

        var query = {
            expand: "organization"
        }

        changepasswordRequest.clear()
        changepasswordRequest.query = query;
        changepasswordRequest.body = body;
        changepasswordRequest.path = `/api/collections/tellers/records/${dsController.loggedUser.id}`
        var res = changepasswordRequest.send();

        console.log(JSON.stringify(res))

        if(res.status===200) {
            // Extract data
            var user = res.data            
            var orgDataExists = user.hasOwnProperty('expand') &&
                    user.expand.hasOwnProperty('organization')
            var org = (user.organization==='' || !orgDataExists) ?
                        null : user.expand.organization

            // Set new values to settings
            dsController.loggedUser = user;
            dsController.organization = org ? org : {};
            dsController.workspaceId = org ? org.id : '';

            clearInputs()

            // Check if user should reset password first ...
            if(user.reset_password_on_login) {
                toast.warning(qsTr("Before you go, you are required to set a new password!"))
                mandatoryResetPassword()
            }

            // Check if user is part of an organization,
            // if not so, go to create organization.
            else if(!org || !org.id || (org && org.id==='')) {
                toast.warning(qsTr("We couldn't find any organization for you!"))
                mandatoryCreateOrGetOrganization()
            }

            else {
                // All checks fine, lets then check if we can log in finally!
                dsController.isLoggedIn = checkIfLoggedIn()

                // Show toast message
                toast.success(qsTr("Login Success!"))
            }
        } else {
            // console.log(JSON.stringify(res))
            // User creation failed
            messageBox.showMessage(
                        qsTr("Change Password Failed"), Utils.error(res))
        }
    }

    function clearInputs() {
        oldpasswordInput.input.clear()
        newpasswordInput.input.clear()
        cnewpasswordInput.input.clear()
    }

    function mandatoryResetPassword() {
        stack.pop()
        stack.push("qrc:/ui/views/auth/ChangePassword.qml",
                   { stack: navigationStack }, StackView.Immediate)
    }

    function mandatoryCreateOrGetOrganization() {
        stack.pop()
        stack.push("qrc:/ui/views/auth/CreateOrJoinOrganization.qml",
                                       {
                                           stack: navigationStack
                                       }, StackView.Immediate)
    }
}
