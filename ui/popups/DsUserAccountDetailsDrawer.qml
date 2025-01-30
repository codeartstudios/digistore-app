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

        property ListModel fieldsModel: ListModel {}
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

                ScrollBar.vertical: ScrollBar{ }

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

                        Layout.fillWidth: true
                        Layout.leftMargin: Theme.baseSpacing
                        Layout.rightMargin: Theme.baseSpacing
                    }

                    Repeater {
                        id: productslv
                        width: scrollview.width
                        // Layout.leftMargin: Theme.baseSpacing
                        // Layout.rightMargin: Theme.baseSpacing
                        // Layout.bottomMargin: Theme.baseSpacing

                        // clip: true
                        // spacing: Theme.xsSpacing
                        model: (userData && userData.permissions) ? userData.permissions : []

                        // ScrollBar.vertical: ScrollBar{ id: psb }

                        delegate: Rectangle {
                            width: psb.visible ? productslv.width - psb.width : productslv.width
                            height: pcol.height + Theme.smSpacing

                            Column {
                                id: pcol
                                spacing: Theme.xsSpacing/2
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.leftMargin: Theme.xsSpacing
                                anchors.rightMargin: Theme.xsSpacing
                                anchors.verticalCenter: parent.verticalCenter

                                DsLabel {
                                    color: Theme.txtPrimaryColor
                                    fontSize: Theme.xlFontSize
                                    text: `${model.unit} ${model.name}`
                                }

                                RowLayout {
                                    width: parent.width
                                    height: Theme.xsBtnHeight

                                    DsLabel {
                                        color: Theme.txtHintColor
                                        fontSize: Theme.xsFontSize
                                        text: `${model.quantity} x KES ${model.selling_price}`
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    DsLabel {
                                        color: Theme.txtHintColor
                                        fontSize: Theme.xsFontSize
                                        text: `KES ${model.quantity * model.selling_price}`
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Row {
                Layout.preferredHeight: Theme.btnHeight
                Layout.alignment: Qt.AlignRight
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.bottomMargin: Theme.xsSpacing

                DsButton {
                    text: qsTr("Close")
                    bgColor: Theme.primaryColor
                    textColor: Theme.baseColor
                    anchors.verticalCenter: parent.verticalCenter

                    onClicked: root.close()
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
                    checked: root.userData ? root.userData[model.key] : ""
                    enabled: false
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }
    }

    function defaultSettings() {
        var data = {
            can_add_stock: false,
            can_remove_stock: false,
            can_add_products: false,
            can_update_products: false,
            can_remove_products: false,
            can_sell_product: false,
            can_edit_org: false,
            can_add_org_users: false,
            can_edit_org_users: false,
        }
    }
}
