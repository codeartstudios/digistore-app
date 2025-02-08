import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.qmlmodels
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

        property var accountPermissions: null
        property var accountSwitches: ({})

        property bool loaded: false
        property string requestType: ""

        // Check if the current current matches the logged user account, a.k.a `myAccount`
        property bool isMyAccount: userData!==null && userData.id===dsController.loggedUser.id

        property ListModel fieldsModel: ListModel {}
        property var permissionModel: null

        // Check if any input fileds were edited ...
        // First, check if the window `loaded` flag is set,if not return `false`
        // If, loaded, check for:
        //      - Either the `accountSwitches` object has value(s) in it (non empty) -> return true
        //      - Else, check whether the `userData["permissions"]` & `permissionModel` are not equal
        property bool fieldsEdited: loaded ? (Object.keys(accountSwitches).length > 0 ||
                                              (accountPermissions !== null && userData &&
                                               !Utils.isJSONEqual(userData["permissions"], permissionModel)))
                                             ? true : false  : false

        // Check if current user has the `is_admin` flag set
        property bool accountIsAdmin: (userData && userData["is_admin"] === true ) ? true : false
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
                    visible: !internal.isMyAccount && loggedUserPermissions.canEditPermissions
                    iconType: IconType.userMinus
                    busy: request.running && internal.requestType==="deleteAccount"
                    enabled: !request.running
                    text: qsTr("Delete Account")
                    bgColor: Theme.dangerColor
                    textColor: Theme.baseColor
                    Layout.alignment: Qt.AlignVCenter

                    onClicked: deleteAccount()
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
                Layout.bottomMargin: bottomRowLayout.visible ? 0 : Theme.baseSpacing
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

                    Repeater {
                        width: scrollview.width
                        model: internal.fieldsModel
                        delegate: chooser

                        DelegateChooser {
                            id: chooser
                            role: "type"

                            DelegateChoice {
                                roleValue: "label"

                                Rectangle {
                                    width: scrollview.width
                                    height: Theme.btnHeight

                                    RowLayout {
                                        width: parent.width
                                        height: Theme.btnHeight
                                        spacing: Theme.xsSpacing/2

                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.leftMargin: Theme.xsSpacing
                                        anchors.rightMargin: Theme.xsSpacing
                                        anchors.verticalCenter: parent.verticalCenter

                                        DsLabel {
                                            color: Theme.txtPrimaryColor
                                            fontSize: Theme.xlFontSize
                                            text: model.label
                                            Layout.fillWidth: true
                                            Layout.alignment: Qt.AlignVCenter
                                        }

                                        DsLabel {
                                            color: Theme.txtPrimaryColor
                                            fontSize: Theme.xlFontSize
                                            text: formatText(root.userData)
                                            Layout.alignment: Qt.AlignVCenter

                                            function formatText(txt) {
                                                if(!txt) return qsTr("None")
                                                var m = root.userData[model.key]
                                                if(model.key==="mobile") {
                                                    if(!m) return qsTr("None");
                                                    return `(${m.dial_code})${m.number}`
                                                }
                                                return root.userData[model.key]
                                            }
                                        }
                                    }
                                }
                            }

                            DelegateChoice {
                                roleValue: "switch"

                                Rectangle {
                                    width: scrollview.width
                                    height: Theme.btnHeight

                                    RowLayout {
                                        width: parent.width
                                        height: Theme.btnHeight
                                        spacing: Theme.xsSpacing/2

                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.leftMargin: Theme.xsSpacing
                                        anchors.rightMargin: Theme.xsSpacing
                                        anchors.verticalCenter: parent.verticalCenter

                                        DsLabel {
                                            color: Theme.txtPrimaryColor
                                            fontSize: Theme.xlFontSize
                                            text: model.label
                                            Layout.fillWidth: true
                                            Layout.alignment: Qt.AlignVCenter
                                        }

                                        // NOTE: We can't edit `verified` field as a normal user
                                        // only done by admin accounts, in this case, pocketbase
                                        // admin account not organization admin account
                                        DsSwitch {
                                            checked: root.userData ? root.userData[model.key] : false
                                            enabled: !internal.isMyAccount && model.key!=="verified" &&
                                                     ((root.userData && root.userData.is_admin) ||
                                                      loggedUserPermissions.canEditPermissions)
                                            Layout.alignment: Qt.AlignVCenter

                                            onCheckedChanged: if(internal.loaded && root.userData)
                                                                  internal.accountSwitches[model.key] = checked
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // If the user has the `is_admin` flag set,
                    // hide individual permission flags, not needed.
                    Column {
                        width: scrollview.width
                        spacing: Theme.xsSpacing
                        visible: !internal.accountIsAdmin   // Show for non-admins

                        DsLabel {
                            color: Theme.txtPrimaryColor
                            fontSize: Theme.h3
                            text: qsTr("User Permissions")
                            topPadding: Theme.xsSpacing
                            width: scrollview.width
                        }

                        // The model for the repeater is generated from `permissionModel` JSON
                        // object keys. When JSON object is null, this throws an error, so we pass
                        // empty array '[]'
                        Repeater {
                            id: productslv
                            width: scrollview.width
                            model: internal.permissionModel ? Object.keys(internal.permissionModel) : []
                            delegate: Rectangle {
                                id: productlvDelegate
                                width: scrollview.width
                                height: Theme.btnHeight
                                color: Theme.baseColor
                                radius: Theme.btnRadius

                                property string key: modelData  // JSON Object Key
                                property string label: getLabel(key)    // Convert the key to a string (remove '_')
                                property bool value: internal.permissionModel[key]

                                RowLayout {
                                    width: parent.width
                                    height: Theme.btnHeight
                                    spacing: Theme.xsSpacing/2

                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.leftMargin: Theme.xsSpacing
                                    anchors.rightMargin: Theme.xsSpacing
                                    anchors.verticalCenter: parent.verticalCenter

                                    DsLabel {
                                        color: Theme.txtPrimaryColor
                                        fontSize: Theme.xlFontSize
                                        text: productlvDelegate.label
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    // Only allow editing user permissions if the selected user
                                    // account is not 'myAccount' and logged in user has permission
                                    // to edit user permissions
                                    DsSwitch {
                                        checked: productlvDelegate.value
                                        enabled: loggedUserPermissions.canEditPermissions &&
                                                 !internal.isMyAccount
                                        Layout.alignment: Qt.AlignVCenter

                                        onCheckedChanged: if(internal.loaded) { // Avoid setting model when we are setting up
                                                              // Insert  if not exits the key and value
                                                              // If exists, update it
                                                              // NOTE: This change DOES NOT trigger signal change
                                                              internal.permissionModel[key] = checked

                                                              // To trigger the permissionModel changed signal, we have
                                                              // to do an assignment
                                                              internal.permissionModel = internal.permissionModel
                                                          }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Show this section only if the fields were changed and
            // we have permissions to do permissions changes and
            // we are not editing any user permissions.
            RowLayout {
                id: bottomRowLayout
                visible: !internal.isMyAccount && internal.fieldsEdited &&
                         loggedUserPermissions.canEditPermissions
                spacing: Theme.xsSpacing/2
                Layout.preferredHeight: visible ? Theme.btnHeight : 0
                Layout.alignment: Qt.AlignRight
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.bottomMargin: Theme.xsSpacing

                Behavior on height{ NumberAnimation { easing.type: Easing.InOutQuad }}

                Item {
                    Layout.fillWidth: true
                    height: 1
                }

                DsButton {
                    busy: request.running && internal.requestType==="updateUser"
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

    Requests {
        id: request
        token: dsController.token
        baseUrl: dsController.baseUrl
    }

    function getLabel(lbl) {
        return lbl.split("_").map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(" ")
    }

    function populateModel(perm) {
        internal.permissionModel = perm
    }

    onOpened: {
        internal.loaded = false
        internal.fieldsModel.clear()
        internal.permissionModel = null

        internal.fieldsModel.append({ key: "name", label: "Name", type: "label" })
        internal.fieldsModel.append({ key: "username", label: "Username", type: "label" })
        internal.fieldsModel.append({ key: "email", label: "Email", type: "label" })
        internal.fieldsModel.append({ key: "verified", label: "Is Verfied?", type: "switch" })
        internal.fieldsModel.append({ key: "approved", label: "Is Approved?", type: "switch" })
        internal.fieldsModel.append({ key: "is_admin", label: "Is Admin?", type: "switch" })
        internal.fieldsModel.append({ key: "mobile", label: "Mobile", type: "label", fn: function(val) {
            return val ? `(${val.dial_code})${val.number}` : 'None'} })

        if(userData) {
            var perm = null

            // If user has `permission` obj, use it, else
            // use default permissions template
            if(userData["permissions"]) {
                perm = userData["permissions"]
            } else {
                perm = globalModels.userPermissonsTemplate
            }

            internal.accountPermissions = perm
            internal.permissionModel = perm
        }

        // Reset Account Switches
        internal.accountSwitches = {}

        // Set loaded flag, a.k.a. we are done setting up
        internal.loaded = true
    }

    onClosed: {
        internal.requestType    = ""
        root.userData           = null
        internal.loaded         = false
    }

    function deleteAccount() {
        // Set request type
        internal.requestType = "deleteAccount"

        // User ID
        var id = root.userData.id;

        // Reset Request Data
        request.clear()
        request.path = `/api/collections/tellers/records/${id}`
        request.method = "DELETE"
        var res = request.send();

        if(res.status===204) {
            // Show delete message and close drawer ...
            toast.success(qsTr("User account deleted!"))
            root.close()
            root.userDeleted()

        }

        else if(res.status === 0) {
            showMessage(
                        qsTr("Account Delete Error"),
                        qsTr("Could not connect to the server, something is'nt right!")
                        )
        }

        else if(res.status === 400) {
            showMessage(
                        qsTr("Account Delete Error"),
                        qsTr("Failed to delete record. Make sure that the record is not part of a required relation reference.")
                        )
        }

        else if(res.status === 404) {
            showMessage(
                        qsTr("Account Delete Error"),
                        qsTr("The requested resource wasn't found.")
                        )
        }

        else {
            showMessage(
                        qsTr("Account Delete Error"),
                        res.message ? res.message : qsTr("Yuck! Something not right here!")
                        )
        }
    }

    function resetPassword(){
    }

    function updateUser() {
        // Set request type
        internal.requestType = "updateUser"

        // User ID
        var id = root.userData.id;

        var body = {
            name: root.userData.name,
            mobile: root.userData.mobile,
            // Overwrite permission to default template if user is admin
            permissions: internal.accountSwitches['is_admin'] ?
                globalModels.userPermissonsTemplate : internal.accountPermissions
        }

        // If we have any account switches, use them to overwrite the switches
        // in the body
        var accSwitchKeys = Object.keys(internal.accountSwitches)
        accSwitchKeys.forEach((key) => {
                                  body[key] = internal.accountSwitches[key]
                              })

        // Reset Request Data
        request.clear()
        request.body = body
        request.path = `/api/collections/tellers/records/${id}`
        request.method = "PATCH"
        var res = request.send();

        if(res.status===200) {
            root.close()
            root.userUpdated()
        }

        else if(res.status === 0) {
            showMessage(
                        qsTr("Connection Refused"),
                        qsTr("Could not connect to the server, something is'nt right!")
                        )
        }

        else if(res.status === 403) {
            showMessage(
                        qsTr("Authentication Error"),
                        qsTr("You don't seem to have access rights to perform this action.")
                        )
        }

        else {
            showMessage(
                        qsTr("Error Occured"),
                        res.message ? res.message : qsTr("Yuck! Something not right here!")
                        )
        }
    }
}
