import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.qmlmodels
import QtQuick.Dialogs
import app.digisto.modules

import "../controls"

DsDrawer {
    id: root
    width: Math.min(500, mainApp.width * 0.9)

    // Hold selected user data
    property var userData: null

    signal userDeleted()
    signal userUpdated()

    QtObject {
        id: internal

        property bool loaded: false
        property string requestType: ""

        // Check if the current current matches the
        // logged user account, a.k.a `myAccount`
        property bool isMyAccount: userData!==null &&
                                   userData.id===dsController.loggedUser.id

        // Check if any input fileds were edited ...
        property bool edited: false
    }

    contentItem: Item {
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            spacing: Theme.smSpacing

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.lgBtnHeight
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.topMargin: Theme.smSpacing
                spacing: Theme.smSpacing

                DsLabel {
                    fontSize: Theme.h1
                    color: Theme.txtHintColor
                    text: qsTr("User Account")
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                }

                Item {
                    Layout.fillWidth: true
                    height: 1
                }

                DsButton {
                    visible: !internal.isMyAccount &&
                             dsPermissionManager.canDeleteUserAccounts
                    iconType: IconType.userMinus
                    busy: request.running && internal.requestType==="deleteAccount"
                    enabled: !request.running
                    text: qsTr("Delete Account")
                    bgColor: Theme.dangerColor
                    textColor: Theme.baseColor
                    Layout.alignment: Qt.AlignVCenter

                    onClicked: dialog.open()
                }
            }

            Rectangle {
                width: scrollview.width
                color: Theme.warningAltColor
                visible: internal.isMyAccount

                Layout.fillWidth: true
                Layout.preferredHeight: visible ? Theme.btnHeight : 0
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing

                DsLabel {
                    color: Theme.warningColor
                    fontSize: Theme.lgFontSize
                    text: qsTr("This is your account, you can't edit it.")
                    anchors.centerIn: parent
                }
            }

            DsLabel {
                color: Theme.txtPrimaryColor
                fontSize: Theme.h3
                text: qsTr("Account Details")
                topPadding: Theme.xsSpacing

                Layout.fillWidth: true
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
            }

            ScrollView {
                id: scrollview
                Layout.fillWidth: true
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.bottomMargin: Theme.baseSpacing
                Layout.fillHeight: true

                clip: true

                Keys.onUpPressed: scrollBar.decrease()
                Keys.onDownPressed: scrollBar.increase()

                ScrollBar.vertical: ScrollBar{
                    id: scrollBar
                    hoverEnabled: true
                    active: hovered || pressed
                    anchors.left: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                }

                Column {
                    width: scrollview.width
                    spacing: Theme.xsSpacing

                    DsAccountInfoDelegateLabelItem {
                        label: qsTr('Name')
                        value: userData ? userData.name : '---'
                    }

                    DsAccountInfoDelegateLabelItem {
                        label: qsTr('Email')
                        value: userData ? userData.email : '---'
                    }

                    DsAccountInfoDelegateLabelItem {
                        label: qsTr('Verified')
                        value: userData ? userData.verified : false
                    }

                    DsAccountInfoDelegateLabelItem {
                        label: qsTr('Mobile')
                        value: formatText(userData)

                        function formatText(obj) {
                            if(!obj || obj.mobile) return qsTr("None")
                            return `(${obj.mobile.dial_code})${obj.mobile.number}`
                        }
                    }

                    DsAccountInfoDelegateComboItem {
                        id: rolecb
                        model: globalModels.rolesModel
                        currentIndex: getIndex(userData)
                        label: qsTr('User Role')
                        hasPermissions: dsPermissionManager.canUpdateUserAccounts &&
                                        !internal.isMyAccount

                        function getIndex(obj) {
                            if(!obj || !obj.role) return -1
                            for(var i=0; i<model.length; i++) {
                                if(model[i].id===obj.role) {
                                    return i;
                                }
                            }

                            return -1
                        }

                        onCurrentIndexChanged: if(internal.loaded)
                                                   internal.edited=true
                    }

                    DsButton {
                        visible: !internal.isMyAccount && internal.edited &&
                                 dsPermissionManager.canUpdateUserAccounts
                        width: parent.width
                        busy: request.running &&
                              internal.requestType==="updateUser"
                        enabled: !request.running
                        text: qsTr("Update User")
                        bgColor: Theme.successColor
                        textColor: Theme.baseColor
                        Layout.alignment: Qt.AlignVCenter

                        onClicked: updateUser()
                    }
                }
            }
        }
    }

    Requests {
        id: request
        token: dsController.token
        baseUrl: dsController.baseUrl
    }

    MessageDialog {
        id: dialog
        text: qsTr("Deleting User Account")
        informativeText: qsTr("Are you sure you want to delete this user? This action can't be undone.")
        buttons: MessageDialog.Yes | MessageDialog.No

        onButtonClicked: (btn, role) => {
                             switch(btn) {
                                 case MessageDialog.Yes:
                                 deleteAccount()
                                 break;
                             }
                         }
    }

    DsToast{
        id: toast
        x: (parent.width - width)/2
        width: 300
    }

    // ------------------------------------------------ //
    onOpened: {
        internal.loaded     = false
        internal.edited     = false

        // Load the current index for the roles cb
        rolecb.currentIndex = rolecb.getIndex(userData)

        // Close any toast if it was left running
        toast.close()

        // Set loaded flag, a.k.a. we are done setting up
        internal.loaded = true
    }

    onClosed: {
        internal.requestType    = ""
        root.userData           = null
        internal.loaded         = false
        internal.edited         = true
    }
    // ------------------------------------------------ //

    function deleteAccount() {
        if(!dsPermissionManager.canDeleteUserAccounts) {
            showPermissionDeniedWarning(toast)
            return
        }

        // Set request type
        internal.requestType = "deleteAccount"

        // User ID
        var id = root.userData.id;

        // Reset Request Data
        request.clear()
        request.path = `/api/collections/tellers/records/${id}`
        request.method = "DELETE"
        var res = request.send();
        console.log(Utils.maybeJSON(res))

        if(res.status===204) {
            // Show delete message and close drawer ...
            toast.success(qsTr("User account deleted!"))
            root.userDeleted()
        }

        else if(res.status === 0) {
            toast.error(qsTr("Could not connect to the server, something is'nt right!"))
        }

        else {
            toast.error(Utils.error(res))
        }
    }

    function resetPassword(){ }

    function updateUser() {
        if(!dsPermissionManager.canUpdateUserAccounts) {
            showPermissionDeniedWarning(toast)
            return
        }

        var role = rolecb.model[rolecb.currentIndex].id
        console.log(role)

        // Set request type
        internal.requestType = "updateUser"

        // User ID
        var id = root.userData.id;

        var body = {
            name: root.userData.name,
            mobile: root.userData.mobile,
            role
        }

        // Reset Request Data
        request.clear()
        request.body = body
        request.path = `/api/collections/tellers/records/${id}`
        request.method = "PATCH"
        var res = request.send();

        if(res.status===200) {
            internal.edited = true
            // root.close()
            root.userUpdated()
            toast.success(qsTr("User Updated Successfully!"))
        }

        else if(res.status === 0) {
            toast.error(qsTr("Could not connect to the server, something is'nt right!"))
        }

        else {
            toast.error(Utils.error(res))
        }
    }
}
