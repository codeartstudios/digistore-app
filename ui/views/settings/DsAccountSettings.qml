import QtQuick
import QtQuick.Layouts
import app.digisto.modules

import "controls" // Settings
import "../../controls"

DsSettingsStackPage {
    id: root
    title: qsTr("Account")

    DsSettingsCard {
        id: accountdetailscard
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
                    source: "qrc:/assets/imgs/no-profile.png"
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
                        mandatory: true
                        color: Theme.baseAlt2Color
                        label: qsTr("Fullname")
                        input.placeholderText: qsTr("John Doe")
                        Layout.fillWidth: true
                    }

                    DsInputWithLabel {
                        mandatory: true
                        color: Theme.baseAlt2Color
                        label: qsTr("Mobile Number")
                        input.placeholderText: qsTr("user@email.com")
                        Layout.fillWidth: true
                    }
                }

                RowLayout {
                    width: parent.width
                    spacing: Theme.xsSpacing

                    DsInputWithLabel {
                        mandatory: true
                        color: Theme.baseAlt2Color
                        label: qsTr("Organization")
                        input.placeholderText: "Some Org."
                        Layout.fillWidth: true
                    }

                    DsInputWithLabel {
                        mandatory: true
                        color: Theme.baseAlt2Color
                        isPasswordInput: true
                        label: qsTr("Date Created")
                        input.placeholderText: "2020-12-11"
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }

    DsSettingsCard {
        id: accountemailcard
        title: qsTr("Account Email")
        desc: qsTr("Update user email.")

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
                color: Theme.baseAlt2Color
                label: qsTr("New Email")
                input.placeholderText: qsTr("user@email.com")
                Layout.fillWidth: true
            }

            DsInputWithLabel {
                id: newemailinputconf
                mandatory: true
                color: Theme.baseAlt2Color
                label: qsTr("Confirm Email")
                input.placeholderText: qsTr("user@email.com")
                Layout.fillWidth: true
            }

            DsInputWithLabel {
                id: passwordinputemailupdate
                mandatory: true
                color: Theme.baseAlt2Color
                isPasswordInput: true
                label: qsTr("Account Password")
                input.placeholderText: "********"
                Layout.fillWidth: true
            }
        }
    }

    DsSettingsCard {
        id: accountpasswordcard
        title: qsTr("Account Password")
        desc: qsTr("Update user password.")

        property bool updatePasswordBtnShown: !(oldpasswordinput.text.trim()==="" &&
                                                newpasswordinput.text.trim()==="" &&
                                                newpasswordinputconfirm.text.trim()==="")

        actions: [
            DsButton {
                visible: accountpasswordcard.updatePasswordBtnShown
                text: qsTr("Update Password")
                onClicked: updatePassword()
            }
        ]

        RowLayout {
            width: parent.width

            DsInputWithLabel {
                id: oldpasswordinput
                mandatory: true
                input.placeholderText: qsTr("********")
                label: qsTr("Old Password")
                color: Theme.baseAlt2Color
                Layout.fillWidth: true
            }

            DsInputWithLabel {
                id: newpasswordinput
                mandatory: true
                label: qsTr("New Password")
                input.placeholderText: qsTr("********")
                color: Theme.baseAlt2Color
                Layout.fillWidth: true
            }

            DsInputWithLabel {
                id: newpasswordinputconfirm
                mandatory: true
                isPasswordInput: true
                label: qsTr("Confirm New Password")
                color: Theme.baseAlt2Color
                input.placeholderText: qsTr("********")
                Layout.fillWidth: true
            }
        }
    }

    DsSettingsCard {
        id: passwordresetcard
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
        title: qsTr("Delete Account")
        desc: qsTr("This removes user account data and some associated actions. This can't be undone.")

        DsButton {
            bgColor: Theme.dangerAltColor
            textColor: Theme.dangerColor
            text: qsTr("Delete Account")
            Layout.alignment: Qt.AlignVCenter
            onClicked: deleteAccount()
        }
    }

    function updateUser() {

    }

    function updateEmail() {

    }

    function updatePassword() {

    }

    function resetPassword() {

    }

    function signOut() {

    }

    function deleteAccount() {

    }
}
