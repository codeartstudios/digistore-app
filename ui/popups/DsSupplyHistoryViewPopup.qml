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

    property string sortByKey: "created"
    property bool sortAsc: true

    property ListModel datamodel: ListModel{}
    property real xOffset: mapToGlobal(0,0).x

    onXOffsetChanged: console.log("> ", xOffset)

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

                onAccepted: (txt) => getSupplys(txt)
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
            title: qsTr("Supplier")
            sortable: true
            width: 200
            flex: 2
            value: "expand.suppliers.name"
        }

        ListElement {
            title: qsTr("Amount")
            sortable: true
            width: 150
            flex: 1
            value: "amount"
            formatBy: (amount) => `KES. ${amount}`
        }

        ListElement {
            title: qsTr("Date Added")
            sortable: true
            width: 200
            flex: 2
            value: "created"
            formatBy: (dt) => Qt.formatDateTime(new Date(dt), 'ddd MMM dd, yyyy hh:mm ap')
        }
    }

    Requests {
        id: getsupplysrequest
        token: dsController.token
        baseUrl: dsController.baseUrl
        path: "/api/collections/supply/records"
    }

    function getSupplys(txt='') {
        var query = {
            page: pageNo,
            perPage: itemsPerPage,
            sort: `${ sortAsc ? '+' : '-' }${ sortByKey }`,
            filter: `organization='${dsController.workspaceId}'` + (txt==='' ? '' : ` && (amount ~ '${txt}' || suppliers ~ '${txt}')`),
            expand: "suppliers",
            fields: "*,expand.suppliers.name"
        }

        getsupplysrequest.clear()
        getsupplysrequest.query = query;
        var res = getsupplysrequest.send();

        root.datamodel.clear()

        if(res.status===200) {
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
            showMessage(qsTr("Supply Fetch Error!"),
                        qsTr("Only admins can perform this task!"))
        }

        else {
            showMessage(qsTr("Supply Fetch Error!"),
                        `${res.status.toString()} - ${res.data.message}`)
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
