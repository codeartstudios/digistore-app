import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import app.digisto.modules

import "../controls"

Popup {
    id: root
    width: mainApp.width * 0.7
    height: mainApp.height * 0.7
    modal: true
    x: (mainApp.width-width)/2
    y: (mainApp.height-height)/2
    closePolicy: Popup.NoAutoClose

    property real pageNo: 1
    property real totalPages: 0
    property real totalItems: 0
    property real itemsPerPage: 100

    property string sortByKey: "name"
    property bool sortAsc: true

    property ListModel datamodel: ListModel{}

    background: Rectangle {
        color: Theme.bodyColor
        radius: Theme.btnRadius
    }

    contentItem: Item {
        anchors.fill: parent

        ColumnLayout {
            spacing: Theme.baseSpacing
            anchors.fill: parent

            RowLayout { // Header
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.btnHeight
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.topMargin: Theme.xsSpacing

                DsLabel {
                    fontSize: Theme.h1
                    color: Theme.txtHintColor
                    text: qsTr("Inventory")
                    Layout.alignment: Qt.AlignVCenter
                }

                DsLabel {
                    fontSize: Theme.h1
                    color: Theme.txtHintColor
                    text: qsTr("/")
                    Layout.alignment: Qt.AlignVCenter
                }

                DsLabel {
                    fontSize: Theme.h2
                    color: Theme.txtPrimaryColor
                    text: qsTr("Supply")
                    Layout.alignment: Qt.AlignVCenter
                }

                DsIconButton {
                    enabled: !getsupplysrequest.running
                    iconType: IconType.reload
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                    radius: height/2
                    Layout.alignment: Qt.AlignVCenter

                    onClicked: getSupplys()
                }

                Item {
                    Layout.fillWidth: true
                    height: 1
                }

                DsButton {
                    iconType: IconType.tablePlus
                    text: qsTr("New Supply")
                    onClicked: newsupplypopup.open()
                }

                DsIconButton {
                    iconType: IconType.x
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                    radius: height/2
                    Layout.alignment: Qt.AlignVCenter

                    onClicked: root.close()
                }
            } // Header

            DsSearchInputNoPopup {
                id: dsSearchInput
                busy: getsupplysrequest.running
                placeHolderText: qsTr("Who are you looking for?")
                Layout.preferredHeight: Theme.lgBtnHeight
                Layout.fillWidth: true
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing

                onAccepted: (txt) => getSuppliers(txt)
            }

            DsTable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing

                headerModel: headermodel
                dataModel: root.datamodel
                busy: getsupplysrequest.running

                onSortBy: function(key) {
                    if(key===sortByKey) {
                        sortAsc = !sortAsc;
                    } else {
                        sortAsc = true;
                    }

                    sortByKey = key;

                    getSuppliers()
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.btnHeight
                Layout.bottomMargin: Theme.baseSpacing

                DsBusyIndicator {
                    width: Theme.btnHeight
                    height: Theme.btnHeight
                    running: getsupplysrequest.running
                    visible: running
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                }

                Row {
                    spacing: Theme.btnRadius
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.baseSpacing

                    DsLabel {
                        text: qsTr("Total Items  ") + `${totalItems}  `
                        color: Theme.txtHintColor
                        fontSize: Theme.smFontSize
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    DsIconButton {
                        enabled: pageNo>1 && !getsupplysrequest.running
                        iconType: IconType.arrowLeft
                        textColor: Theme.txtPrimaryColor
                        bgColor: "transparent"
                        bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                        bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                        onClicked: {
                            pageNo -= 1
                            getSuppliers()
                        }
                    }

                    DsLabel {
                        text: `${pageNo} / ${totalPages}`
                        color: Theme.txtHintColor
                        fontSize: Theme.smFontSize
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    DsIconButton {
                        enabled: pageNo<totalPages && !getsupplysrequest.running
                        iconType: IconType.arrowRight
                        textColor: Theme.txtPrimaryColor
                        bgColor: "transparent"
                        bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                        bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                        onClicked: {
                            pageNo += 1
                            getSuppliers()
                        }
                    }
                }
            }
        }
    }

    ListModel {
        id: headermodel

        ListElement {
            title: qsTr("Unit")
            sortable: true
            width: 100
            flex: 0
            value: "unit"
        }

        ListElement {
            title: qsTr("Product Name")
            sortable: true
            width: 300
            flex: 2
            value: "name"
        }

        ListElement {
            title: qsTr("Barcode")
            sortable: true
            width: 150
            flex: 0
            value: "barcode"
        }

        ListElement {
            title: qsTr("Buying Price")
            sortable: true
            width: 200
            flex: 1
            value: "buying_price"
        }

        ListElement {
            title: qsTr("Selling Price")
            sortable: true
            width: 200
            flex: 1
            value: "selling_price"
        }

        ListElement {
            title: qsTr("Stock")
            sortable: true
            width: 200
            flex: 1
            value: "stock"
        }
    }

    Requests {
        id: getsupplysrequest
        path: "/api/collections/supply/records"
    }

    function getSupplys(txt='') {
        var query = {
            page: pageNo,
            perPage: itemsPerPage,
            sort: `${ sortAsc ? '+' : '-' }${ sortByKey }`,
            // filter: `organization='${dsController.organizationID}'` + (txt==='' ? '' : ` && (name ~ '${txt}' || mobile ~ '${txt}' || email ~ '${txt}')`)
        }

        getsupplysrequest.clear()
        getsupplysrequest.query = query;
        var res = getsupplysrequest.send();
        console.log(JSON.stringify(res))

        if(res.status===200) {
            console.log("200")
            var data = res.data;
            pageNo=data.page
            totalPages=data.totalPages
            totalItems=data.totalItems
            var items = data.items;

            root.datamodel.clear()

            for(var i=0; i<items.length; i++) {
                root.datamodel.append(items[i])
            }
        }

        else if(res.status===403) {
            showMessage(qsTr("Supply Fetch Error!"), qsTr("Only admins can perform this task!"))
        }

        else {
            showMessage(qsTr("Supply Fetch Error!"), `${res.status.toString()} - ${res.data.message}`)
        }
    }

    // New Supply Addition
    DsNewSupplyPopup {
        id: newsupplypopup
    }

    // MessageBox popup for warnings/errors/info
    DsMessageBox {
        id: messageBox
        z: parent.z
        x: (root.width-width)/2
        y: (root.height-height)/2
    }

    function showMessage(title="", info="") {
        messageBox.title = title
        messageBox.info = info
        messageBox.open()
    }

    onOpened: getSupplys()
}
