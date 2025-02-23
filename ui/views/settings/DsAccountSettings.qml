import QtQuick
import QtQuick.Layouts
import app.digisto.modules

import "../../controls"
import "../../js/main.js" as DsMain

DsSettingsStackPage {
    id: root
    title: qsTr("Account")

    DsSettingsCard {
        id: accountdetailscard
        width: root.width
        title: qsTr("Account Details")
        desc: qsTr("User account information.")

        property bool updateUserBtnShown: false

        actions: [
            DsButton {
                visible: accountdetailscard.updateUserBtnShown
                text: qsTr("Update User")
                onClicked: updateUser()
            }
        ]

        RowLayout {
            spacing: Theme.xsSpacing
            width: parent.width

            Rectangle {
                radius: height/2
                color: Theme.bodyColor
                Layout.fillHeight: true
                Layout.preferredWidth: height

                DsImage {
                    source: "qrc:/assets/imgs/no-profile.jpg"
                    radius: height/2
                    anchors.fill: parent
                }
            }

            Column {
                spacing: Theme.xsSpacing
                Layout.fillWidth: true

                RowLayout {
                    width: parent.width
                    spacing: Theme.xsSpacing

                    DsInputWithLabel {
                        readOnly: true
                        mandatory: true
                        color: Theme.bodyColor
                        label: qsTr("Fullname")
                        text: (dsController.loggedUser && dsController.loggedUser.name) ?
                                  dsController.loggedUser.name: ""
                        input.placeholderText: qsTr("John Doe")
                        Layout.fillWidth: true
                    }

                    DsInputWithLabel {
                        readOnly: true
                        mandatory: true
                        color: Theme.bodyColor
                        label: qsTr("Mobile")
                        text: getNumber(dsController.loggedUser.mobile)
                        input.placeholderText: qsTr("(+1) 234 567 89")
                        Layout.fillWidth: true

                        function getNumber(mobile) {
                            if(!mobile) return ''
                            return `(${mobile.dial_code ? mobile.dial_code : '+--'}) ${mobile.number ? mobile.number : 'xxx xxx xxx'}`
                        }
                    }

                    //     DsInputMobileNumber {
                    //         id: usermobile
                    //         readOnly: true
                    //         mandatory: true
                    //         color: Theme.bodyColor
                    //         text: getNumber(dsController.loggedUser.mobile)
                    //         label: qsTr("Mobile Number")
                    //         input.placeholderText: qsTr("ie. 712234123")
                    //         Layout.fillWidth: true

                    //         secondaryActionLabel.visible: false

                    //         function getNumber(mobile) {
                    //             // Set mobile number
                    //             text = mobile.number ? mobile.number : ''

                    //             // Set Dial Code
                    //             if(mobile.dial_code)
                    //                 usermobile.findAndSetCountryByDialCode(mobile.dial_code)
                    //         }
                    //     }

                }

                RowLayout {
                    width: parent.width
                    spacing: Theme.xsSpacing

                    DsInputWithLabel {
                        readOnly: true
                        mandatory: true
                        color: Theme.bodyColor
                        text: (dsController.organization && dsController.organization.name) ?
                                  dsController.organization.name : ""
                        label: qsTr("Organization")
                        input.placeholderText: "Some Org."
                        Layout.fillWidth: true
                    }

                    DsInputWithLabel {
                        readOnly: true
                        mandatory: true
                        color: Theme.bodyColor
                        text: formatDate(dsController.loggedUser.created)
                        label: qsTr("Date Joined")
                        input.placeholderText: "2020-12-11"
                        Layout.fillWidth: true

                        function formatDate(dt) {
                            if(!dt) return ''
                            var date = new Date(dt)
                            return Qt.formatDateTime(date, 'dd/MM/yyyy hh:mm AP')
                        }
                    }
                }
            }
        }
    }

    // TODO
    // Update user email
    DsSettingsCard {
        id: accountemailcard
        width: root.width
        title: qsTr("Account Email")
        desc: qsTr("Update user email.")
        visible: false

        property bool updateEmailBtnShown: !(newemailinput.text.trim()==="" &&
                                             newemailinputconf.text.trim()==="" &&
                                             passwordinputemailupdate.text.trim()===""
                                             )

        actions: [
            DsButton {
                visible: accountemailcard.updateEmailBtnShown
                text: qsTr("Update Email")
                onClicked: updateEmail()
            }
        ]

        RowLayout {
            width: parent.width

            DsInputWithLabel {
                id: newemailinput
                mandatory: true
                color: Theme.bodyColor
                label: qsTr("New Email")
                input.placeholderText: qsTr("user@email.com")
                Layout.fillWidth: true
            }

            DsInputWithLabel {
                id: newemailinputconf
                mandatory: true
                color: Theme.bodyColor
                label: qsTr("Confirm Email")
                input.placeholderText: qsTr("user@email.com")
                Layout.fillWidth: true
            }

            DsInputWithLabel {
                id: passwordinputemailupdate
                mandatory: true
                color: Theme.bodyColor
                isPasswordInput: true
                label: qsTr("Account Password")
                input.placeholderText: "********"
                Layout.fillWidth: true
            }
        }
    }

    DsSettingsCard {
        id: accountpasswordcard
        width: root.width
        title: qsTr("Account Password")
        desc: qsTr("Update user password.")

        // function resetCard() {
        //     oldpasswordInput.text = ""
        //     newpasswordInput.text = ""
        //     cnewpasswordInput.text = ""
        // }

        property bool updatePasswordBtnShown: !(oldpasswordInput.text.trim()==="" &&
                                                newpasswordInput.text.trim()==="" &&
                                                cnewpasswordInput.text.trim()==="")

        actions: [
            DsButton {
                visible: accountpasswordcard.updatePasswordBtnShown
                text: qsTr("Update Password")
                bgColor: Theme.warningAltColor
                onClicked: updatePassword()
            }
        ]

        RowLayout {
            width: parent.width

            DsInputWithLabel {
                id: oldpasswordInput
                mandatory: true
                input.placeholderText: qsTr("********")
                label: qsTr("Old Password")
                color: Theme.bodyColor
                Layout.fillWidth: true
            }

            DsInputWithLabel {
                id: newpasswordInput
                mandatory: true
                label: qsTr("New Password")
                input.placeholderText: qsTr("********")
                color: Theme.bodyColor
                Layout.fillWidth: true
            }

            DsInputWithLabel {
                id: cnewpasswordInput
                mandatory: true
                isPasswordInput: true
                label: qsTr("Confirm New Password")
                color: Theme.bodyColor
                input.placeholderText: qsTr("********")
                Layout.fillWidth: true
            }
        }
    }

    DsSettingsCard {
        id: passwordresetcard
        width: root.width
        title: qsTr("Password Reset")
        desc: qsTr("A temporary password will be sent to your associated email.")

        RowLayout {
            width: parent.width

            DsLabel {
                text: qsTr("Request password reset")
                fontSize: Theme.baseFontSize
                color: Theme.txtPrimaryColor
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }

            DsButton {
                endIcon: IconType.arrowNarrowRight
                text: qsTr("Reset")
                Layout.alignment: Qt.AlignVCenter

                onClicked: resetPassword()
            }
        }
    }

    DsSettingsCard {
        width: root.width
        title: qsTr("Sign Out")
        desc: qsTr("End the current logged in session.")

        DsButton {
            bgColor: Theme.dangerAltColor
            textColor: Theme.dangerColor
            endIcon: IconType.logout
            text: qsTr("Sign Out")
            Layout.alignment: Qt.AlignVCenter
            onClicked: signOut()
        }
    }

    RowLayout {
        visible: false
        width: root.width
        spacing: Theme.xsSpacing

        Rectangle {
            color: Theme.dangerColor
            height: 1
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        DsLabel {
            color: Theme.dangerColor
            text: qsTr("DANGER")
        }

        Rectangle {
            color: Theme.dangerColor
            height: 1
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }
    }

    DsSettingsCard {
        visible: false
        width: root.width
        title: qsTr("Delete Account")
        desc: qsTr("This removes user account data and some associated actions. This can't be undone.")

        property bool orgAllowsDeletingAccount: (dsController.organization &&
                                                 dsController.organization.settings &&
                                                 dsController.organization.settings.users_can_delete_own_accounts) ? true : false

        DsButton {
            bgColor: Theme.dangerAltColor
            textColor: Theme.dangerColor
            text: qsTr("Delete Account")
            Layout.alignment: Qt.AlignVCenter
            onClicked: deleteAccount()
        }
    }

    // Page resources
    Requests {
        id: resetpasswordRequest
        baseUrl: dsController.baseUrl
        token: dsController.token
        method: "POST"
        path: '/api/collections/tellers/request-password-reset'
    }

    Requests {
        id: changepasswordRequest
        baseUrl: dsController.baseUrl
        token: dsController.token
        method: "PATCH"
    }

    function updateUser() {

    }

    function updateEmail() {

    }

    function updatePassword() {
        var oldpassword = oldpasswordInput.input.text.trim()
        var newpassword = newpasswordInput.input.text.trim()
        var cnewpassword = cnewpasswordInput.input.text.trim()

        if(oldpassword < 5) {
            oldpasswordInput.hasError = true;
            oldpasswordInput.errorString = qsTr("Old password is too short!")
            return;
        }

        if(newpassword.length < 8) {
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

        // console.log(JSON.stringify(res))

        if(res.status===200) {
            // Extract data
            var user = res.data
            var orgDataExists = user.hasOwnProperty('expand') &&
                    user.expand.hasOwnProperty('organization')
            var org = (user.organization==='' || !orgDataExists) ?
                        null : user.expand.organization

            if(user && user.id !== "") {
                // Set new values to settings
                dsController.loggedUser = user;
            }

            // Update org details if valid
            if(org && org.id!=='') {
                dsController.organization = org ? org : {};
                dsController.workspaceId = org ? org.id : '';
            }

            // Show toast message
            toast.success(qsTr("Password was reset, use your new password in your next login!"))

            // Clear card
            accountpasswordcard.resetCard()

        } else {
            // console.log(JSON.stringify(res))
            // User creation failed
            messageBox.showMessage(
                        qsTr("Change Password Failed"),
                        res.data.message ?
                            res.data.message : res.error ?
                                res.error : qsTr("We couldn't complete this request, please try again later.")
                        )
        }
    }


    function resetPassword() {
        // Check for valid user email before we proceed
        if(!dsController.loggedUser || dsController.loggedUser.email==='') {
            toast.error(qsTr("Invalid user email record found, something isn't  right!"))
            return
        }

        resetpasswordRequest.clear()
        resetpasswordRequest.body = {
            email: dsController.loggedUser.email
        }

        const res = resetpasswordRequest.send()

        if(res.status===204) {
            toast.success(qsTr("Request submitted, check your email."))
        } else {
            toast.error(res.data.message)
        }
    }

    function signOut() {
        DsMain.logout()
    }

    function deleteAccount() {

    }
}
