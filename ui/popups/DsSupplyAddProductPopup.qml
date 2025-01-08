import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.platform
import app.digisto.modules

import "../controls"

DsPopup {
    id: root
    height: qtyiwl.height + Theme.xsSpacing
    borderColor: Theme.baseAlt1Color
    borderWidth: 1

    property var selectedSupplier: null
    property ListModel supplyProductsModel: ListModel {}

    onOpened: clearInputs()


    contentItem: Item {
        anchors.fill: parent

        RowLayout {
            spacing: Theme.xsSpacing/2
            anchors.fill: parent
            anchors.margins: Theme.xsSpacing/2

            DsInputSelectorWithSearch {
                collection: "product"
                displayFields: ["unit", "name"]
                label: qsTr("Product")
                allowMultipleSelection: false
                mandatory: true
                Layout.preferredHeight: qtyiwl.height
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }

            DsInputWithLabel {
                id: qtyiwl
                label: qsTr("Quantity")
                validator: IntValidator{ bottom: 1 }
                input.placeholderText: "1"
                mandatory: true
                Layout.preferredWidth: 100
                Layout.alignment: Qt.AlignVCenter
            }

            DsInputWithLabel {
                id: bpiwl
                label: qsTr("Buying Price")
                validator: IntValidator{ bottom: 1 }
                input.placeholderText: "0.0"
                mandatory: true
                Layout.preferredWidth: 100
                Layout.alignment: Qt.AlignVCenter
            }

            DsIconButton {
                Layout.preferredHeight: qtyiwl.height
                Layout.preferredWidth: Theme.btnHeight
                radius: Theme.btnRadius
                iconType: IconType.plus
            }
        }
    }

    function clearInputs() {
        //nameinput.input.text=""
        //emailinput.input.text=""
        //mobileinput.input.text=""
    }
}
