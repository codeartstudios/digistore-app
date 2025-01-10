import QtQuick
import QtQuick.Layouts
import app.digisto.modules

import "controls" // Settings
import "../../controls"

DsSettingsStackPage {
    id: root
    title: qsTr("Account")

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
            }
        ]

        RowLayout {
            width: parent.width

            DsInputWithLabel {
                id: newemailinput
                mandatory: true
                color: Theme.baseAlt2Color
                label: qsTr("New Email")
                Layout.fillWidth: true
            }

            DsInputWithLabel {
                id: newemailinputconf
                mandatory: true
                color: Theme.baseAlt2Color
                label: qsTr("Confirm Email")
                Layout.fillWidth: true
            }

            DsInputWithLabel {
                id: passwordinputemailupdate
                mandatory: true
                color: Theme.baseAlt2Color
                isPasswordInput: true
                label: qsTr("Account Password")
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

        RowLayout {
            width: parent.width

            DsLabel {
                text: qsTr("Request password reset")
                fontSize: Theme.baseFontSize
                color: Theme.txtPrimaryColor
                Layout.fillWidth: true
            }

            DsComboBox {
                Layout.minimumWidth: 300
                currentIndex: 0
                radius: Theme.btnRadius
                model: [qsTr("Light Theme"), qsTr("Dark Theme"), qsTr("Same as system")]
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

    function resetPassword() {

    }

    function signOut() {

    }
}
