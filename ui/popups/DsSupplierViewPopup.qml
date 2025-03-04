import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.platform
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

            RowLayout {
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
                    text: qsTr("Suppliers")
                    Layout.alignment: Qt.AlignVCenter
                }

                DsIconButton {
                    enabled: !getsuppliersrequest.running
                    iconType: IconType.reload
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                    radius: height/2
                    Layout.alignment: Qt.AlignVCenter

                    onClicked: getSuppliers()
                }

                Item {
                    Layout.fillWidth: true
                    height: 1
                }

                DsButton {
                    enabled: dsPermissionManager.canCreateSuppliers
                    iconType: IconType.playlistAdd
                    text: qsTr("New Supplier")
                    onClicked: newsupplierpopup.open()
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
            }

            DsSearchInputNoPopup {
                id: dsSearchInput
                busy: getsuppliersrequest.running
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
                headerModel: headermodel
                dataModel: datamodel
                busy: getsuppliersrequest.running

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
                    running: getsuppliersrequest.running
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
                        enabled: pageNo>1 && !getsuppliersrequest.running
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
                        enabled: pageNo<totalPages && !getsuppliersrequest.running
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
            width: 300
            flex: 2
            value: "name"
        }

        ListElement {
            title: qsTr("Mobile")
            sortable: true
            width: 200
            flex: 1
            value: "mobile"
        }

        ListElement {
            title: qsTr("Email")
            sortable: true
            width: 200
            flex: 1
            value: "email"
        }
    }

    Requests {
        id: getsuppliersrequest
        token: dsController.token
        baseUrl: dsController.baseUrl
        path: "/api/collections/suppliers/records"
    }

    function getSuppliers(txt='') {
        // Check for permissions before proceeding ...
        if(!dsPermissionManager.canViewSuppliers) {
            showMessage(qsTr("Yuck!"),
                        qsTr("Seems you don't have access to this feature, check with your admin!"))
            return;
        }

        var query = {
            page: pageNo,
            perPage: itemsPerPage,
            sort: `${ sortAsc ? '+' : '-' }${ sortByKey }`,
            filter: `organization='${dsController.workspaceId}'` +
                    (txt==='' ? '' : ` && (name ~ '${txt}' || mobile ~ '${txt}' || email ~ '${txt}')`)
        }

        // console.log(JSON.stringify(query))
        getsuppliersrequest.clear()
        getsuppliersrequest.query = query;
        var res = getsuppliersrequest.send();

        if(res.status===200) {
            var data = res.data;
            pageNo=data.page
            totalPages=data.totalPages
            totalItems=data.totalItems
            var items = data.items;

            datamodel.clear()

            for(var i=0; i<items.length; i++) {
                datamodel.append(items[i])
            }
        }

        else if(res.status >= 400 || res.status < 200) {
            showMessage(qsTr("Supplier Error!"),
                        res.data.message)
        }

        else {
            showMessage(qsTr("Supplier Error!"), qsTr("Error fetching supplier list, error ")+res.status.toString())
        }
    }

    onOpened: getSuppliers()
}
