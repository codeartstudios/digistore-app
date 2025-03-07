import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import app.digisto.modules

Rectangle {
    id: root
    color: Theme.shadowColor
    radius: Theme.btnRadius
    visible: selectedObject
    implicitHeight: selectedObject ? Theme.lgBtnHeight : 0

    Behavior on implicitHeight { NumberAnimation {} }

    property var selectedObject: null
    property int currentIndex: -1

    DsBusyIndicator {
        width: Theme.btnHeight
        height: Theme.btnHeight
        // running: searchitemrequest.running
        visible: running
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
    }

    RowLayout {
        spacing: Theme.btnRadius
        anchors.fill: parent
        anchors.rightMargin: Theme.xsSpacing/2
        anchors.leftMargin: Theme.xsSpacing/2

        property alias obj: root.selectedObject

        DsIconButton {
            enabled: !searchitemrequest.running
            iconType: IconType.x
            textColor: Theme.dangerColor
            bgColor: "transparent"
            bgHover: withOpacity(Theme.dangerAltColor, 0.8)
            bgDown: withOpacity(Theme.dangerAltColor, 0.6)
            radius: height/2
            Layout.alignment: Qt.AlignVCenter

            onClicked: table.currentIndex=-1
        }

        DsLabel {
            text: qsTr("Name")
            color: Theme.txtHintColor
            fontSize: Theme.lgFontSize
            rightPadding: Theme.smSpacing
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: Theme.smSpacing
        }

        DsLabel {
            text: parent.obj ? `${parent.obj.unit} ${parent.obj.name}` : ""
            color: Theme.txtPrimaryColor
            fontSize: Theme.lgFontSize
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
        }

        DsLabel {
            text: qsTr("Quantity")
            color: Theme.txtHintColor
            fontSize: Theme.lgFontSize
            rightPadding: Theme.smSpacing
            Layout.alignment: Qt.AlignVCenter
        }

        QQCB.SpinBox {
            id: qtysbox
            Layout.preferredHeight: Theme.btnHeight
            Layout.preferredWidth: 200
            value: parent.obj ? parent.obj.quantity : 1
            from: 1
            editable: true
        }

        Item { height: 1; Layout.preferredWidth: 50 }

        DsButton {
            text: qsTr("Update")
            iconType: IconType.circleCheck

            onClicked: {
                // var index = table.currentIndex
                // var qty = qtysbox.value
                // var sp = parent.obj.selling_price

                // cartModel.set(index, { quantity: qty, subtotal: qty*sp })
                // calculateTotals()

                // table.currentIndex=-1
            }
        }

        DsButton {
            text: qsTr("Remove")
            iconType: IconType.trashX
            textColor: Theme.dangerColor
            bgColor: "transparent"
            bgHover: withOpacity(Theme.dangerAltColor, 0.8)
            bgDown: withOpacity(Theme.dangerAltColor, 0.6)
            borderColor: Theme.dangerColor
            borderWidth: 1

            onClicked: {
                // cartModel.remove(table.currentIndex);
                // calculateTotals();
            }
        }
    }
}

