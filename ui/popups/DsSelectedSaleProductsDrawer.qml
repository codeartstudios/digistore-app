import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

import "../controls"

DsDrawer {
    id: root
    width: 500

    property var dataModel: null

    onOpened: {
        // Only if the model is valid
        if(dataModel) {
            internal.totals = dataModel.totals
            internal.dateCreated =dataModel.created
            internal.products = dataModel.products

            var _payments = dataModel.payments
            var payments = []       // Temporary items hold
            var keys = Object.keys(dataModel.payments)

            keys.forEach((key) => {
                             // Only add non zero items
                             if(_payments[key].amount > 0) {
                                 payments.push(_payments[key])
                             }

                         });

            // Update the payments property
            internal.payments = payments
        }
    }

    QtObject {
        id: internal

        property real totals
        property real dateCreated
        property var products: []
        property var payments: []
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
                    text: qsTr("Sale View")
                    Layout.alignment: Qt.AlignVCenter
                }

                DsLabel {
                    fontSize: Theme.h1
                    color: Theme.txtHintColor
                    text: qsTr("/")
                    Layout.alignment: Qt.AlignVCenter
                }

                DsLabel {
                    fontSize: Theme.h1
                    color: Theme.txtHintColor
                    text: `KES ${internal.totals}`
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            DsLabel {
                color: Theme.txtPrimaryColor
                fontSize: Theme.h3
                text: qsTr("Payment Scheme")
                topPadding: Theme.xsSpacing

                Layout.fillWidth: true
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
            }

            ListView {
                id: paymentslv
                Layout.fillWidth: true
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.preferredHeight: model.length * Theme.btnHeight + spacing * model.length

                clip: true
                spacing: Theme.xsSpacing
                model: internal.payments

                ScrollBar.vertical: ScrollBar{ }

                delegate: Rectangle {
                    width: paymentslv.width
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
                            text: `${modelData.label}`
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                        }

                        DsLabel {
                            color: Theme.txtPrimaryColor
                            fontSize: Theme.xlFontSize
                            text: `KES ${modelData.amount}`
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }
                }
            }

            DsLabel {
                color: Theme.txtPrimaryColor
                fontSize: Theme.h3
                text: qsTr("Sale Items")
                topPadding: Theme.xsSpacing

                Layout.fillWidth: true
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
            }

            ListView {
                id: productslv
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.bottomMargin: Theme.baseSpacing

                clip: true
                spacing: Theme.xsSpacing
                model: internal.products

                ScrollBar.vertical: ScrollBar{ id: psb }

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
}
