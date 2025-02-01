import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.qmlmodels
import app.digisto.modules

import "../controls"

DsDrawer {
    id: root
    width: 500
    topCloseButtonShown: false

    // Hold selected user data
    property var userData: null

    signal reloadTellers()

    onClosed: {
        internal.requestType = ""
        userData = null
    }

    QtObject {
        id: internal

        property string requestType: ""
        property bool isMyAccount: userData!==null && userData.id===dsController.loggedUser.id
        property bool isAdmin: userData!==null &&  userData.is_admin===true
        property bool canEditPermissions: userData!==null && userData.permissions &&  userData.permissions.can_manage_users===true
        property ListModel fieldsModel: ListModel {}
        property ListModel permissionModel: ListModel {}
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

                DsButton {
                    text: qsTr("Close")
                    bgColor: Theme.primaryColor
                    textColor: Theme.baseColor
                    Layout.alignment: Qt.AlignVCenter

                    onClicked: root.close()
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
                Layout.fillHeight: true

                clip: true

                Keys.onUpPressed: scrollBar.decrease()
                Keys.onDownPressed: scrollBar.increase()

                ScrollBar.vertical: ScrollBar{
                    id: scrollBar
                    hoverEnabled: true
                    active: hovered || pressed
                    anchors.right: parent.right
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
                                            bgColor: Theme.bodyColor
                                            checked: root.userData ? root.userData[model.key] : ""
                                            enabled: !internal.isMyAccount &&
                                                     ((root.userData && root.userData.is_admin) ||
                                                      internal.canEditPermissions)
                                            Layout.alignment: Qt.AlignVCenter
                                        }
                                    }
                                }
                            }
                        }
                    }

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
                        model: internal.permissionModel
                        delegate: switchDelegate
                    }
                }
            }

            RowLayout {
                visible: !internal.isMyAccount
                spacing: Theme.xsSpacing/2
                Layout.preferredHeight: visible ? Theme.btnHeight : 0
                Layout.alignment: Qt.AlignRight
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.bottomMargin: Theme.xsSpacing

                DsButton {
                    busy: request.running && internal.requestType==="deleteAccount"
                    enabled: !request.running
                    text: qsTr("Delete Account")
                    bgColor: Theme.dangerColor
                    textColor: Theme.baseColor
                    Layout.alignment: Qt.AlignVCenter

                    onClicked: deleteAccount()
                }

                DsButton {
                    busy: request.running && internal.requestType==="resetPassword"
                    enabled: !request.running
                    text: qsTr("Reset Password")
                    bgColor: Theme.primaryColor
                    textColor: Theme.baseColor
                    Layout.alignment: Qt.AlignVCenter

                    onClicked: resetPassword()
                }

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

    Component {
        id: switchDelegate

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
                    checked: model.value
                    enabled: internal.canEditPermissions && !internal.isMyAccount
                    Layout.alignment: Qt.AlignVCenter
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
        let keys = Object.keys(perm)
        keys.forEach((key) => {
                         var p = {
                             key,
                             value: perm[key],
                             label: getLabel(key)
                         }
                         internal.permissionModel.append(p)
                     })
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

        internal.permissionModel.clear()

        if(userData) {
            if(userData["permissions"]) {
                var perm = userData["permissions"]
                populateModel(perm)
            } else {
                let perm = {
                    can_add_stock: false,
                    can_manage_stock: false,
                    can_sell_products: false,
                    can_add_products: false,
                    can_manage_products: false,
                    can_add_suppliers: false,
                    can_manage_suppliers: false,
                    can_manage_sales: false,
                    can_manage_inventory: false,
                    can_manage_org: false,
                    can_manage_users: false,
                }
                populateModel(perm)
            }
        }
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
            root.close()
            console.log("Account Deleted ...")
            showMessage(
                        qsTr("Account Delete Success!"),
                        qsTr("Selected Account Deleted Successfully!")
                        )
            root.reloadTellers()
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
    }
}
