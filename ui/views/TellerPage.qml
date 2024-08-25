import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Universal as QQCC2
import QtQuick.Layouts
import Qt.labs.qmlmodels
import app.digisto.modules

import "../controls"

/*
  TellerPage
*/

DsPage {
    id: loginPage
    title: qsTr("Teller Page")

    headerShown: false

    ColumnLayout {
        anchors.fill: parent
        spacing: Theme.xsSpacing



        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.lgBtnHeight
            Layout.leftMargin: Theme.xsSpacing
            Layout.rightMargin: Theme.xsSpacing

            RowLayout {
                anchors.fill: parent
                spacing: Theme.xsSpacing

                DsLabel {
                    text: qsTr("Teller")
                    fontSize: Theme.h3
                    Layout.alignment: Qt.AlignVCenter
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                DsLabel {
                    text: qsTr("Totals: KES. 45,878.98")
                    fontSize: Theme.h2
                    Layout.alignment: Qt.AlignVCenter
                    Layout.rightMargin: 20
                }

                DsButton {
                    iconType: IconType.shoppingCart
                    height: Theme.btnHeight
                    text: qsTr("Checkout (F5)")
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }

        Rectangle {
            border.color: Theme.baseAlt1Color
            border.width: 1
            radius: Theme.btnRadius
            color: "transparent"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: Theme.xsSpacing
            Layout.rightMargin: Theme.xsSpacing
            Layout.bottomMargin: Theme.xsSpacing

            HorizontalHeaderView {
                id: horizontalHeader
                syncView: tableView
                clip: true
                implicitHeight: Theme.lgBtnHeight
                model: ["", "#", "Product", "Quantity", "Unit Price", "Totals"]
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top

                delegate: DelegateChooser {
                    DelegateChoice {
                        index: 0
                        delegate: Rectangle {
                            color: Theme.baseAlt1Color
                            height: Theme.lgBtnHeight
                            implicitHeight: Theme.lgBtnHeight

                            DsCheckBox {
                                cbSize: Theme.btnHeight
                                checked: false
                                onToggled: {
                                    model.display = checked
                                    setChecked(checked)
                                }

                                anchors.centerIn: parent
                            }
                        }
                    }

                    DelegateChoice {
                        index: 1
                        delegate: Rectangle {
                            color: Theme.baseAlt1Color
                            height: Theme.lgBtnHeight
                            implicitHeight: Theme.lgBtnHeight

                            DsLabel {
                                fontSize: Theme.h2
                                text: model.modelData
                                anchors.centerIn: parent
                            }
                        }
                    }

                    DelegateChoice {
                        delegate: Rectangle {
                            color: Theme.baseAlt1Color
                            height: Theme.lgBtnHeight
                            implicitHeight: Theme.lgBtnHeight

                            DsLabel {
                                fontSize: Theme.h2
                                text: model.modelData
                                leftPadding: Theme.smSpacing/2
                                rightPadding: Theme.smSpacing/2

                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }

            TableView {
                id: tableView

                property var columnFlex: [{ width: Theme.lgBtnHeight }, { width: Theme.lgBtnHeight }, { flex: 3 }, { flex: 1 }, { flex: 1 },{ flex: 1 }]

                alternatingRows: true
                clip: true
                columnSpacing: 1
                rowSpacing: 1
                columnWidthProvider: (column) => {
                                         var widthSum = 0
                                         var flexSum = 0
                                         columnFlex.forEach((item) => {
                                                                if(item.width) widthSum += item.width
                                                                else flexSum += item.flex
                                                            })

                                         var obj = columnFlex[column]
                                         if(obj.width) return obj.width;

                                         var workingWidth = tableView.width - widthSum - ((tableView.columns-1) * tableView.columnSpacing)
                                         return workingWidth * (obj.flex/flexSum)
                                     }
                anchors.left: parent.left
                anchors.top: horizontalHeader.bottom
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                model: TableModel {
                    TableModelColumn { display: "checked" }
                    TableModelColumn { display: "index" }
                    TableModelColumn { display: "name" }
                    TableModelColumn { display: "quantity"; edit: () => {} }
                    TableModelColumn { display: "price" }
                    TableModelColumn { display: "totals" }

                    rows: [
                        {
                            "checked": false,
                            "index": 0,
                            "name": "2kg Soko Cooking Flour",
                            "quantity": 4,
                            "price": 220,
                            "totals": 880
                        },
                        {
                            "checked": false,
                            "index": 1,
                            "name": "2kg Soko Cooking Flour",
                            "quantity": 4,
                            "price": 220,
                            "totals": 880
                        },
                        {
                            "checked": false,
                            "index": 30,
                            "name": "2kg Soko Cooking Flour",
                            "quantity": 4,
                            "price": 220,
                            "totals": 880
                        }
                    ]
                }


                delegate: DelegateChooser {
                    DelegateChoice {
                        column: 0
                        delegate: Item {
                            implicitHeight: Theme.lgBtnHeight

                            DsCheckBox {
                                cbSize: Theme.btnHeight
                                checked: model.display
                                onToggled: model.display = checked

                                anchors.centerIn: parent
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width; height: 1
                                color: Theme.baseAlt1Color
                            }
                        }
                    }

                    DelegateChoice {
                        column: 1
                        delegate: Item {
                            implicitHeight: Theme.lgBtnHeight

                            DsLabel {
                                fontSize: Theme.baseFontSize
                                text: (row+1).toString()+"."
                                width: parent.width - Theme.baseSpacing
                                anchors.centerIn: parent
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width; height: 1
                                color: Theme.baseAlt1Color
                            }
                        }
                    }

                    DelegateChoice {
                        column: 2
                        delegate: Item {
                            implicitHeight: Theme.lgBtnHeight

                            DsLabel {
                                fontSize: Theme.baseFontSize
                                text: model.display
                                width: parent.width - Theme.baseSpacing
                                anchors.centerIn: parent
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width; height: 1
                                color: Theme.baseAlt1Color
                            }
                        }
                    }

                    DelegateChoice {
                        column: 3
                        delegate: Item {
                            implicitHeight: Theme.lgBtnHeight

                            QQCC2.SpinBox {
                                from: 1
                                editable: true
                                value: model.display
                                height: Theme.btnHeight
                                width: parent.width - Theme.baseSpacing
                                onValueModified: model.display = value

                                anchors.centerIn: parent
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width; height: 1
                                color: Theme.baseAlt1Color
                            }
                        }
                    }


                    DelegateChoice {
                        column: 4
                        delegate: Item {
                            implicitHeight: Theme.lgBtnHeight

                            DsLabel {
                                text: model.display
                                fontSize: Theme.baseFontSize
                                width: parent.width - Theme.baseSpacing
                                anchors.centerIn: parent
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width; height: 1
                                color: Theme.baseAlt1Color
                            }
                        }
                    }

                    DelegateChoice {
                        column: 5
                        delegate: Item {
                            implicitHeight: Theme.lgBtnHeight

                            DsLabel {
                                fontSize: Theme.baseFontSize
                                text: model.display
                                width: parent.width - Theme.baseSpacing
                                anchors.centerIn: parent
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width; height: 1
                                color: Theme.baseAlt1Color
                            }
                        }
                    }
                }
            }
        }
    }

    function setChecked(checked) {

    }
}
