import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.platform
import app.digisto.modules

import "../controls"

Popup {
    id: root
    width: 800
    height: 500
    modal: true
    x: (mainApp.width-width)/2
    y: (mainApp.height-height)/2
    closePolicy: Popup.NoAutoClose

    onOpened: clearInputs()

    background: Rectangle {
        color: Theme.bodyColor
        radius: Theme.btnRadius
    }

    contentItem: Item {
        anchors.fill: parent

        ColumnLayout {
            spacing: Theme.baseSpacing
            anchors.fill: parent

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.btnHeight
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.topMargin: Theme.xsSpacing

                DsLabel {
                    fontSize: Theme.h1
                    color: Theme.txtHintColor
                    text: qsTr("New Product")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                }

                DsIconButton {
                    iconType: IconType.x
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                    radius: height/2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right

                    onClicked: root.close()
                }

            }

            ScrollView {
                id: scrollview
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column {
                    width: scrollview.width
                    spacing: Theme.smSpacing

                    Row {
                        spacing: Theme.smSpacing
                        width: parent.width - 2*Theme.baseSpacing
                        anchors.horizontalCenter: parent.horizontalCenter

                        DsInputWithLabel {
                            id: barcodeinput
                            label: qsTr("Barcode")
                            input.placeholderText: qsTr("i.e. 123431423")
                            width: (parent.width-parent.spacing)/2
                        }

                        DsInputWithLabel {
                            id: unitinput
                            label: qsTr("Unit")
                            mandatory: true
                            input.placeholderText: qsTr("i.e. 1pc")
                            width: (parent.width-parent.spacing)/2
                        }
                    }

                    DsInputWithLabel {
                        id: nameinput
                        label: qsTr("Item Name")
                        mandatory: true
                        input.placeholderText: qsTr("i.e. Blue Pen")
                        width: parent.width - 2*Theme.baseSpacing
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Row {
                        spacing: Theme.smSpacing
                        width: parent.width - 2*Theme.baseSpacing
                        anchors.horizontalCenter: parent.horizontalCenter

                        DsInputWithLabel {
                            id: bpinput
                            label: qsTr("Buying Price")
                            input.placeholderText: qsTr("i.e. 500.0")
                            width: (parent.width-parent.spacing)/2
                            validator: IntValidator { bottom: 0 }
                        }

                        DsInputWithLabel {
                            id: spinput
                            label: qsTr("Selling Price")
                            mandatory: true
                            input.placeholderText: qsTr("i.e. 800.0")
                            width: (parent.width-parent.spacing)/2
                            validator: IntValidator { bottom: 0 }
                        }
                    }

                    Row {
                        spacing: Theme.smSpacing
                        width: parent.width - 2*Theme.baseSpacing
                        anchors.horizontalCenter: parent.horizontalCenter

                        DsInputWithLabel {
                            id: stockinput
                            label: qsTr("Stock")
                            input.placeholderText: qsTr("i.e. 20")
                            width: (parent.width-parent.spacing)/2
                            validator: IntValidator{ bottom: 0 }
                        }

                        DsInputWithLabel {
                            id: thumbnailinput
                            label: qsTr("Thumbnail")
                            input.placeholderText: qsTr("i.e. picture")
                            width: (parent.width-parent.spacing)/2
                            onClicked: selectthumbnaildialog.open()
                            readOnly: true
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.btnHeight
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.bottomMargin: Theme.baseSpacing

                Row {
                    spacing: Theme.smSpacing
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right

                    DsButton {
                        busy: addproductrequest.running
                        text: qsTr("Add")
                        iconType: IconType.plus
                        onClicked: addItem()
                    }
                }
            }
        }
    }

    FileDialog {
        id: selectthumbnaildialog
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        fileMode: FileDialog.OpenFile
        nameFilters: ["Image Files (*.png *jpg *jpeg *bmp)"]

        onAccepted: {
            var filePath = file.toString(); // Get the file URL

            if (filePath.startsWith("file:///")) {
                if (dsController.platform==="windows") {
                    // Windows path (e.g., file:///C:/path/to/file.txt)
                    filePath = filePath.substring(8); // Remove "file:///"
                } else {
                    // Linux path (e.g., file:///home/user/file.txt)
                    filePath = filePath.substring(7); // Remove "file://"
                }
            }

            thumbnailinput.input.text=filePath
        }
    }

    Requests {
        id: addproductrequest
        baseUrl: "https://pb.digisto.app"
        path: "/api/collections/product/records"
        method: "POST"
    }

    function addItem() {
        var barcode = barcodeinput.input.text.trim()
        var units = unitinput.input.text.trim()
        var name = nameinput.input.text.trim()
        var bp = bpinput.input.text.trim()
        var sp = spinput.input.text.trim()
        var stock = stockinput.input.text.trim()
        var thumbnail = thumbnailinput.input.text.trim()

        console.log("Thumbanail: ", thumbnail)

        if(units.length===0) {
            return;
        }

        if(name.length <= 2) {
            return;
        }

        if(bp==="") bp=0
        if(sp==="") sp=0
        if(stock==="") stock=0

        var body = {
            name,
            unit: units,
            barcode,
            buying_price: bp,
            selling_price: sp,
            stock: stock,
            organization: "clhyn7tolbhy98k"
        }

        var files = {
            thumbnail
        }

        addproductrequest.clear()
        addproductrequest.body = body
        if(thumbnail!=="") addproductrequest.files = files

        var res = addproductrequest.send();
        console.log(JSON.stringify(res))

        if(res.status===200) {
            root.close()
        } else {
        }
    }

    function clearInputs() {
        barcodeinput.input.text=""
        unitinput.input.text=""
        nameinput.input.text=""
        bpinput.input.text=""
        spinput.input.text=""
        stockinput.input.text=""
        thumbnailinput.input.text=""
        selectthumbnaildialog.file=""
    }
}
