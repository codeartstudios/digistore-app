import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
import app.digisto.modules

import "../controls"

DsDrawer {
    id: root
    width: 500

    property var dataModel: null

    // Flag to hold when we are editing the data
    property bool isEditing: false

    // Product add signals
    signal productAdded
    signal productUpdated
    signal productDeleted

    onOpened: {
        // Ensure scrollview scrolls back to the top
        sv.scrollToTop()

        // Reset input fields to defaults
        clearInputs()

        // Only if the model is valid
        if(!root.isEditing && dataModel) {
            internal.barcode.text   = dataModel['barcode']
            internal.units.text     = dataModel['unit']
            internal.name.text      = dataModel['name']
            internal.bp.text        = dataModel['buying_price']
            internal.sp.text        = dataModel['selling_price']
            internal.stock.text     = dataModel['stock']
            internal.thumbnail      = dataModel['thumbnail'] ? dataModel['thumbnail'] : ""
            var tagObjs = dataModel['tags']
            var tags = []

            for(var i=0; i<tagObjs.count; i++) {
                var obj = tagObjs.get(i)
                tags.push(obj.data)
            }
            internal.tags = tags;
        }

        // Force Active focus to the barcode input
        if(root.isEditing) {
            barcodeinput.input.forceActiveFocus()
        }
    }

    onClosed: resetInputs()

    QtObject {
        id: internal

        property bool toEdit: root.isEditing===true && root.dataModel

        // Cant bind directly to the text value, throws an error
        // ie, with
        // property alias barcode: barcodeinput.input.text
        // Asigning as follows
        //  `barcode = "xyz"`
        // throws list assertation error

        property alias barcode: barcodeinput.input
        property alias units: unitinput.input
        property alias name: nameinput.input
        property alias bp: bpinput.input
        property alias sp: spinput.input
        property alias stock: stockinput.input
        property alias thumbnail: thumbnailinput.file
        property alias tags: categoryinput.dataModel
    }

    contentItem: Item {
        anchors.fill: parent

        ScrollView {
            id: sv
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: btnsitem.top
            anchors.bottomMargin: Theme.xsSpacing

            function scrollToTop() {
                sv.contentItem.contentY = 0
            }

            Column {
                id: col
                width: sv.width
                spacing: Theme.smSpacing

                RowLayout {
                    spacing: Theme.xsSpacing/2
                    height: Theme.lgBtnHeight
                    width: parent.width - 2*Theme.baseSpacing
                    anchors.horizontalCenter: parent.horizontalCenter

                    DsLabel {
                        fontSize: Theme.h1
                        color: Theme.txtHintColor
                        text: root.dataModel ? qsTr("Product View") : qsTr("Create Product")
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Item {
                        Layout.fillWidth: true
                        height: 1
                    }

                    // Product Action Options
                    DsMenu {
                        iconType: IconType.pencilCog
                        text: qsTr("Options")
                        visible: root.dataModel

                        Component.onCompleted: {
                            menuModel.clear()

                            menuModel.append({
                                                 label: qsTr("Edit Product"),
                                                 icon: IconType.databaseEdit
                                             })

                            menuModel.append({
                                                 type: "spacer"
                                             })

                            menuModel.append({
                                                 label: qsTr("Delete Product"),
                                                 icon: IconType.databaseX
                                             })
                        }

                        onCurrentMenuChanged: (ind) => handleDropDownMenuIndexChange(ind)

                        function handleDropDownMenuIndexChange(index) {
                            switch(index) {
                            case 0: {
                                if(dsPermissionManager.canUpdateInventory) {
                                    showPermissionDeniedWarning(toast)
                                    return
                                }

                                root.isEditing=true
                                break
                            }

                            // case 1: is a separator

                            case 2: {
                                if(!dsPermissionManager.canDeleteInventory) {
                                    showPermissionDeniedWarning(toast)
                                    return
                                }

                                dialog.open()
                                break
                            }
                            }
                        }
                    }
                }

                DsLabel {
                    color: Theme.txtPrimaryColor
                    fontSize: Theme.h3
                    text: qsTr("Product Details")
                    topPadding: Theme.xsSpacing

                    width: parent.width - 2*Theme.baseSpacing
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                DsInputWithLabel {
                    id: barcodeinput
                    label: qsTr("Barcode")
                    input.placeholderText: qsTr("i.e. 123431423")
                    readOnly: !(internal.toEdit || root.isEditing)
                    width: parent.width - 2*Theme.baseSpacing
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                DsInputWithLabel {
                    id: unitinput
                    label: qsTr("Unit")
                    mandatory: internal.toEdit || root.isEditing
                    readOnly: !(internal.toEdit || root.isEditing)
                    input.placeholderText: qsTr("i.e. 1pc")
                    width: parent.width - 2*Theme.baseSpacing
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                DsInputWithLabel {
                    id: nameinput
                    label: qsTr("Item Name")
                    mandatory: internal.toEdit || root.isEditing
                    readOnly: !(internal.toEdit || root.isEditing)
                    input.placeholderText: qsTr("i.e. Blue Pen")
                    width: parent.width - 2*Theme.baseSpacing
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                DsInputWithLabel {
                    id: bpinput
                    label: qsTr("Buying Price")
                    readOnly: !(internal.toEdit || root.isEditing)
                    input.placeholderText: qsTr("i.e. 500.0")
                    validator: IntValidator { bottom: 0 }
                    width: parent.width - 2*Theme.baseSpacing
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                DsInputWithLabel {
                    id: spinput
                    label: qsTr("Selling Price")
                    mandatory: internal.toEdit || root.isEditing
                    readOnly: !(internal.toEdit || root.isEditing)
                    input.placeholderText: qsTr("i.e. 800.0")
                    validator: IntValidator { bottom: 0 }
                    width: parent.width - 2*Theme.baseSpacing
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                DsInputWithLabel {
                    id: stockinput
                    label: qsTr("Stock")
                    readOnly: !(!root.dataModel && root.isEditing)
                    input.placeholderText: qsTr("i.e. 20")
                    validator: IntValidator{ bottom: 0 }
                    width: parent.width - 2*Theme.baseSpacing
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                DsInputWithPreview {
                    id: thumbnailinput

                    property string filePath: ""
                    property string file: getFileName(filePath)

                    function clear() {
                        filePath = ""
                        file = ""
                    }

                    enabled: (!root.dataModel && root.isEditing) || internal.toEdit
                    value: file
                    label: qsTr("Thumbnail")
                    placeHolderText: qsTr("Picture .png|.jpg|.jpeg|etc")
                    onClicked: selectthumbnaildialog.open()

                    // Preview Pane setup
                    previewHeight: pimg.visible ? 150 : 0
                    previewContent: Image {
                        id: pimg
                        source: thumbnailinput.filePath!=="" ?
                                    getLocalUrl(thumbnailinput.filePath) : thumbnailinput.file !== "" ?
                                        getOnlineUrl(thumbnailinput.file) : ""
                        visible: thumbnailinput.file!=="" || source!==""
                        height: parent.height
                        width: parent.width
                        fillMode: Image.PreserveAspectFit
                    }

                    width: parent.width - 2*Theme.baseSpacing
                    anchors.horizontalCenter: parent.horizontalCenter

                    secondaryActionLabel {
                        text:qsTr("Remove")
                        color: Theme.dangerColor
                        visible: internal.toEdit && root.dataModel && file!==""
                    }

                    function getFileName(path) {
                        if(!path || path==="") return "";
                        return path.split("/").pop();
                    }

                    onSecondaryAction: {
                        console.log("Secondary Action")
                        filePath = ""
                        file = ""
                    }
                }

                DsInputSelector {
                    id: categoryinput
                    enabled: (!root.dataModel && root.isEditing) || internal.toEdit
                    label: qsTr("Tags")
                    hintText: qsTr("No tags added yet!")
                    placeHolderText: qsTr("Add new tag here")
                    allowMultipleSelection: true
                    width: parent.width - 2*Theme.baseSpacing
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        RowLayout {
            id: btnsitem
            height: isVisible ? Theme.btnHeight : 0
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: Theme.baseSpacing
            anchors.rightMargin: Theme.baseSpacing
            anchors.bottomMargin: Theme.xsSpacing

            Behavior on height { NumberAnimation {} }

            property bool isVisible: (root.isEditing && !root.dataModel) || (internal.toEdit && root.dataModel)

            Item {
                Layout.fillWidth: true
                height: 1
            }

            // Update item button, visible when updating item
            DsButton {
                busy: updateproductrequest.running
                text: qsTr("Update Item")
                iconType: IconType.plus
                enabled: dsPermissionManager.canUpdateInventory
                visible: internal.toEdit && root.dataModel

                onClicked: updateItem()
            }

            // Add item button, visible when only creating item
            DsButton {
                busy: addproductrequest.running
                text: qsTr("Add Item")
                iconType: IconType.plus
                enabled: dsPermissionManager.canCreateInventory
                visible: root.isEditing && !root.dataModel

                onClicked: addItem()
            }
        }
    }

    // Native file dialog to allow picking of image thumbnails
    //  - If a picture is selected, we sanitize the path and
    //    pass it to the request engine for upload.
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

            thumbnailinput.filePath=filePath
            thumbnailinput.file = thumbnailinput.getFileName(filePath)

            console.log(filePath, thumbnailinput.getFileName(filePath), thumbnailinput.file)
        }
    }

    Requests {
        id: addproductrequest
        method: "POST"
        token: dsController.token
        baseUrl: dsController.baseUrl
        path: "/api/collections/product/records"
    }

    Requests {
        id: updateproductrequest
        token: dsController.token
        baseUrl: dsController.baseUrl
        method: "PATCH"
    }

    Requests {
        id: deleteproductrequest
        method: "DELETE"
        token: dsController.token
        baseUrl: dsController.baseUrl
    }

    MessageDialog {
        id: dialog
        text: qsTr("Deleting Product.")
        informativeText: qsTr("Are you sure you want to delete this item? This action can't be undone.")
        buttons: MessageDialog.Yes | MessageDialog.No
        onYesClicked: deleteItem()
    }

    function addItem() {
        // Check for permissions before proceeding ...
        if(!dsPermissionManager.canCreateInventory) {
            showMessage(qsTr("Yuck!"),
                        qsTr("Seems you don't have access to this feature, check with your admin!"))
            return;
        }

        var barcode     = barcodeinput.input.text.trim()
        var units       = unitinput.input.text.trim()
        var name        = nameinput.input.text.trim()
        var bp          = bpinput.input.text.trim()
        var sp          = spinput.input.text.trim()
        var stock       = stockinput.input.text.trim()
        var thumbnail   = thumbnailinput.filePath.trim()
        var tags        = categoryinput.dataModel

        if(units.length===0) {
            showMessage(qsTr("Create Product"),
                        qsTr("Product unit is missing! i.e. 1kg, 1pc, 20ml, 1pck, etc"))
            return;
        }

        if(name.length <= 2) {
            showMessage(qsTr("Create Product"),
                        qsTr("Product name is too short, atleast 3 characters long!"))
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
            tags,
            organization: dsController.workspaceId
        }

        var files = {
            thumbnail
        }

        addproductrequest.clear()
        addproductrequest.body = body
        if(thumbnail!=="") addproductrequest.files = files

        var res = addproductrequest.send();
        // console.log(JSON.stringify(res))

        if(res.status===200) {
            // Emit product add success
            root.productAdded()
            root.close()
        } else {
            showMessage(qsTr("Creating Product Failed"),
                        qsTr("We encountered an error: ") + `[${res.status}] ${res.data.message}`)
        }
    }

    function deleteItem() {
        // Check for permissions before proceeding ...
        if(!dsPermissionManager.canDeleteInventory) {
            showMessage(qsTr("Yuck!"),
                        qsTr("Seems you don't have access to this feature, check with your admin!"))
            return;
        }

        if(!dataModel.id) {
            showMessage(qsTr("Delete Product"),
                        qsTr("Unique product id seems to be missing, something is not right here!"))
            return;
        }

        deleteproductrequest.clear()
        deleteproductrequest.path = `/api/collections/product/records/${dataModel.id}`
        var res = deleteproductrequest.send();
        // console.log(JSON.stringify(res))

        if(res.status===204) {
            var item = `"${dataModel.unit} ${dataModel.name}" `

            // Emit product delete success
            root.productDeleted();
            root.close()
            showMessage(qsTr("Product Deleted"),
                        item + qsTr("deleted successfully!"))
        } else {
            showMessage(qsTr("Delete Product Failed"),
                        qsTr("We encountered an error: ") + `[${res.status}] ${res.data.message}`)
        }
    }

    function updateItem() {
        // Check for permissions before proceeding ...
        if(!dsPermissionManager.canUpdateInventory) {
            showMessage(qsTr("Yuck!"),
                        qsTr("Seems you don't have access to this feature, check with your admin!"))
            return;
        }

        var barcode     = barcodeinput.input.text.trim()
        var units       = unitinput.input.text.trim()
        var name        = nameinput.input.text.trim()
        var bp          = bpinput.input.text.trim()
        var sp          = spinput.input.text.trim()
        var thumbnail   = thumbnailinput.filePath.trim()
        var tags        = categoryinput.dataModel

        if(units.length===0) {
            showMessage(qsTr("Update Product"),
                        qsTr("Product unit is missing! i.e. 1kg, 1pc, 20ml, 1pck, etc"))
            return;
        }

        if(name.length <= 2) {
            showMessage(qsTr("Update Product"),
                        qsTr("Product name is too short, atleast 3 characters long!"))
            return;
        }

        if(!dataModel.id) {
            showMessage(qsTr("Update Product"),
                        qsTr("Unique product id seems to be missing, something is not right here!"))
            return;
        }

        if(bp==="") bp=0
        if(sp==="") sp=0

        var body = {
            name,
            unit: units,
            selling_price: sp,
            organization: dsController.workspaceId
        }

        if(dataModel.barcode !== barcode)
            body["barcode"] = barcode

        if(dataModel.buying_price !== bp)
            body["buying_price"] = bp

        if(dataModel.tags !== tags)
            body["tags"] = tags

        updateproductrequest.clear()

        if(thumbnail!=="" && dataModel.thumbnail!==thumbnailinput.file && thumbnailinput.file!=="") {
            // console.log("Thumbnail added/updated")
            updateproductrequest.files = {
                thumbnail
            }
        }

        if(thumbnail==="") {
            // console.log("Thumbnail removed")
            body["thumbnail"] = null
        }

        updateproductrequest.body = body
        updateproductrequest.path = `/api/collections/product/records/${dataModel.id}`
        var res = updateproductrequest.send();
        // console.log(JSON.stringify(res))

        if(res.status===200) {
            // Emit product update success
            root.productUpdated();
            root.isEditing = false;
        } else {
            showMessage(qsTr("Update Product Failed"),
                        qsTr("We encountered an error: ") + `[${res.status}] ${res.data.message}`)
        }
    }

    function getOnlineUrl(file) {
        // console.log("FILE: ", file)
        if(file==="" || !root.dataModel) return ""
        return `${addproductrequest.baseUrl}/api/files/${root.dataModel.collectionId}/${root.dataModel.id}/${file}`
    }

    function getLocalUrl(path) {
        if(dsController.platform==="windows")
            return `file:///${path}`
        return `file://${path}`
    }

    function clearInputs() {
        barcodeinput.input.text=""
        unitinput.input.text=""
        nameinput.input.text=""
        bpinput.input.text=""
        spinput.input.text=""
        stockinput.input.text=""
        selectthumbnaildialog.file=""
        categoryinput.dataModel = []
        thumbnailinput.clear()
    }

    function resetInputs() {
        clearInputs()

        // Reset model and flags
        root.isEditing = true
        root.dataModel = null
    }
}

