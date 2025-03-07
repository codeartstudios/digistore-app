import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as QQCB
import app.digisto.modules

Rectangle {
    id: root
    color: Theme.shadowColor
    radius: Theme.btnRadius
    visible: model
    height: col.height

    property bool selected: false

    DsMouseArea {
        anchors.fill: parent
        onHoveredChanged: hovered ? root.opacity = 0.7 : root.opacity = 1
        onClicked: supplyitemsListview.currentIndex = index
    }

    Column {
        id: col
        width: parent.width

        RowLayout {
            spacing: Theme.btnRadius
            width: parent.width - Theme.smSpacing
            height: Theme.lgBtnHeight + Theme.smSpacing
            anchors.horizontalCenter: parent.horizontalCenter

            Column {
                spacing: Theme.btnRadius
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                DsLabel {
                    text: qsTr("Name")
                    color: Theme.txtHintColor
                    fontSize: Theme.smFontSize
                    rightPadding: Theme.smSpacing
                }

                DsLabel {
                    height: Theme.btnHeight
                    text: model ? `${model.unit} ${model.name}` : '---'
                    color: Theme.txtPrimaryColor
                    fontSize: Theme.lgFontSize
                    verticalAlignment: DsLabel.AlignVCenter
                }
            }

            Column {
                spacing: Theme.btnRadius
                Layout.alignment: Qt.AlignVCenter

                DsLabel {
                    text: qsTr("Quantity")
                    color: Theme.txtHintColor
                    fontSize: Theme.smFontSize
                    rightPadding: Theme.smSpacing
                }

                QQCB.SpinBox {
                    id: qtysbox
                    Layout.preferredHeight: Theme.btnHeight
                    Layout.preferredWidth: 200
                    from: 1
                    editable: true
                    value: model ? model.quantity : 1

                    onValueChanged: setValue('quantity', value)
                }
            }

            Column {
                spacing: Theme.btnRadius
                Layout.alignment: Qt.AlignVCenter

                DsLabel {
                    color: Theme.txtHintColor
                    fontSize: Theme.smFontSize
                    rightPadding: Theme.smSpacing
                }

                DsIconButton {
                    height: Theme.btnHeight
                    width: Theme.btnHeight
                    iconType: IconType.trashX
                    textColor: Theme.dangerColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.dangerAltColor, 0.8)
                    bgDown: withOpacity(Theme.dangerAltColor, 0.6)
                    borderColor: Theme.dangerColor
                    borderWidth: 1

                    onClicked: {
                        if(selected) currentIndex=-1
                        supplyitemsListview.model.remove(index);
                    }
                }
            }
        }

        Item {
            id: detailsItem
            width: parent.width
            visible: selected
            height: row.height + Theme.smSpacing

            Row {
                id: row
                width: parent.width-Theme.baseSpacing
                spacing: Theme.smSpacing
                anchors.centerIn: parent

                DsInputWithLabel {
                    mandatory: true
                    text: model ? model.buying_price : ''
                    placeholderText: '0.0'
                    label: qsTr("Buying Price")
                    color: Theme.baseColor
                    width: (parent.width-parent.spacing)/2
                    validator: DoubleValidator{ bottom: 0 }

                    onTextChanged: setValue('buying_price', text)
                }

                DsInputWithLabel {
                    mandatory: true
                    text: model ? model.selling_price : ''
                    placeholderText: '0.0'
                    label: qsTr("Selling Price")
                    color: Theme.baseColor
                    width: (parent.width-parent.spacing)/2
                    validator: DoubleValidator{ bottom: 0 }

                    onTextChanged: setValue('selling_price', text)
                }
            }
        }
    }

    function setValue(key, value) {
        supplyitemsListview.model.setProperty(index, key, value)
    }
}

