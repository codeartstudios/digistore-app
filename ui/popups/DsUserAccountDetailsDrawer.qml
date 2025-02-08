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
        property bool isMyAccount: userData!==null && userData.id===dsController.loggedUser.id

        property ListModel fieldsModel: ListModel {}
        property var permissionModel: null

        property bool fieldsEdited: loaded ? Object.keys(accountSwitches).length > 0 ||
                                             (accountPermissions !== null && userData &&
                                              userData["permissions"] !== permissionModel) : false

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

                                        DsSwitch {
                                            // bgColor: Theme.bodyColor
                                            checked: root.userData ? root.userData[model.key] : ""
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

                    Column {
                        width: scrollview.width
                        spacing: Theme.xsSpacing
                        visible: !internal.accountIsAdmin

                        DsLabel {
                            color: Theme.txtPrimaryColor
                            fontSize: Theme.h3
                            text: qsTr("User Permissions")
                            topPadding: Theme.xsSpacing
                            width: scrollview.width
                        }

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

                                property string key: modelData
                                property string label: getLabel(key)
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

                                    DsSwitch {
                                        checked: productlvDelegate.value
                                        enabled: loggedUserPermissions.canEditPermissions && !internal.isMyAccount
                                        Layout.alignment: Qt.AlignVCenter

                                        onCheckedChanged: if(internal.loaded)
                                                              internal.permissionModel[key] = checked
                                    }
                                }
                            }
                        }
                    }
                }
            }

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
        // let keys = Object.keys(perm)
        // keys.forEach((key) => {
        //                  var p = {
        //                      key,
        //                      value: perm[key],
        //                      label: getLabel(key)
        //                  }
        //                  internal.permissionModel.append(p)
        //              })
        internal.permissionModel = perm
    }

    onOpened: {
        internal.fieldsModel.clear()

        internal.fieldsModel.append({ key: "name", label: "Name", type: "label" })
        internal.fieldsModel.append({ key: "username", label: "Username", type: "label" })
        internal.fieldsModel.append({ key: "email", label: "Email", type: "label" })
        internal.fieldsModel.append({ key: "verified", label: "Is Verfied?", type: "switch" })
        internal.fieldsModel.append({ key: "approved", label: "Is Approved?", type: "switch" })
        internal.fieldsModel.append({ key: "is_admin", label: "Is Admin?", type: "switch" })
        internal.fieldsModel.append({ key: "mobile", label: "Mobile", type: "label", fn: function(val) {
            return val ? `(${val.dial_code})${val.number}` : 'None'}
                                    })

        internal.permissionModel = null

        if(userData) {
            if(userData["permissions"]) {
                var perm = userData["permissions"]
                internal.accountPermissions = perm
                populateModel(perm)
            } else {
                internal.accountPermissions = globalModels.userPermissonsTemplate
                populateModel(globalModels.userPermissonsTemplate)
            }
        }

        internal.loaded = true
        internal.accountSwitches = {}
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
            permissions: internal.accountSwitches['is_admin'] ?
                globalModels.userPermissonsTemplate : internal.accountPermissions
        }

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
