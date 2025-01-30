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

    onClosed: userData = null

    QtObject {
        id: internal

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
                                            checked: root.userData ? root.userData[model.key] : ""
                                            enabled: false
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
                spacing: Theme.xsSpacing/2
                Layout.preferredHeight: Theme.btnHeight
                Layout.alignment: Qt.AlignRight
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.bottomMargin: Theme.xsSpacing

                DsButton {
                    text: qsTr("Delete Account")
                    bgColor: Theme.dangerColor
                    textColor: Theme.baseColor
                    Layout.alignment: Qt.AlignVCenter

                    // onClicked: root.close()
                }

                DsButton {
                    text: qsTr("Reset Password")
                    bgColor: Theme.primaryColor
                    textColor: Theme.baseColor
                    Layout.alignment: Qt.AlignVCenter

                    // onClicked: root.close()
                }

                Item {
                    Layout.fillWidth: true
                    height: 1
                }

                DsButton {
                    text: qsTr("Update User")
                    bgColor: Theme.successColor
                    textColor: Theme.baseColor
                    Layout.alignment: Qt.AlignVCenter

                    // onClicked: root.close()
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
                    enabled: internal.canEditPermissions
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }
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

    Component.onCompleted: {
        internal.fieldsModel.clear()
        internal.fieldsModel.append({ key: "name", label: "Name", type: "label" })
        internal.fieldsModel.append({ key: "username", label: "Username", type: "label" })
        internal.fieldsModel.append({ key: "email", label: "Email", type: "label" })
        internal.fieldsModel.append({ key: "verified", label: "Is Verfied?", type: "switch" })
        internal.fieldsModel.append({ key: "approved", label: "Is Approved?", type: "switch" })
        internal.fieldsModel.append({ key: "is_admin", label: "Is Admin?", type: "switch" })
        internal.fieldsModel.append({ key: "mobile", label: "Mobile", type: "label", fn: function(val) { return val ? `(${val.dial_code})${val.number}` : 'None'}  })
    }
}
