import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

import "../controls"
import "../popups"

DsPage {
    id: dashboardPage
    title: ""
    headerShown: false

    property real pageNo: 1
    property real totalPages: 0
    property real totalItems: 0
    property real itemsPerPage: 200

    property string sortByKey: "created"
    property bool sortAsc: false

    // Page properties
    property string salesDateRange: qsTr("Today")

    property ListModel datamodel: ListModel{}

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
                text: qsTr("Sales")
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
                text: salesDateRange
                Layout.alignment: Qt.AlignVCenter
            }

            DsIconButton {
                enabled: !getsalesrequest.running
                iconType: IconType.reload
                textColor: Theme.txtPrimaryColor
                bgColor: "transparent"
                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                radius: height/2
                Layout.alignment: Qt.AlignVCenter

                onClicked: getSales()
            }

            Item {
                Layout.fillWidth: true
                height: 1
            }

            DsButton {
                iconType: IconType.tablePlus
                text: qsTr("New Supplier")
                onClicked: newsupplierpopup.open()
            }
        }

        DsSearchInputNoPopup {
            id: dsSearchInput
            busy: getsalesrequest.running
            placeHolderText: qsTr("Who are you looking for?")
            Layout.preferredHeight: Theme.lgBtnHeight
            Layout.fillWidth: true
            Layout.leftMargin: Theme.baseSpacing
            Layout.rightMargin: Theme.baseSpacing

            onAccepted: (txt) => getSales(txt)
        }

        DsTable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            headerModel: headermodel
            dataModel: datamodel
            busy: getsalesrequest.running

            onSortBy: function(key) {
                if(key===sortByKey) {
                    sortAsc = !sortAsc;
                } else {
                    sortAsc = true;
                }

                sortByKey = key;

                getSales()
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.btnHeight
            Layout.bottomMargin: Theme.baseSpacing

            DsBusyIndicator {
                width: Theme.btnHeight
                height: Theme.btnHeight
                running: getsalesrequest.running
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
                    enabled: pageNo>1 && !getsalesrequest.running
                    iconType: IconType.arrowLeft
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                    onClicked: {
                        pageNo -= 1
                        getSales()
                    }
                }

                DsLabel {
                    text: `${pageNo} / ${totalPages}`
                    color: Theme.txtHintColor
                    fontSize: Theme.smFontSize
                    anchors.verticalCenter: parent.verticalCenter
                }

                DsIconButton {
                    enabled: pageNo<totalPages && !getsalesrequest.running
                    iconType: IconType.arrowRight
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                    onClicked: {
                        pageNo += 1
                        getSales()
                    }
                }
            }
        }
    }

    ListModel {
        id: headermodel

        ListElement {
            title: qsTr("Total Cost")
            sortable: true
            width: 200
            flex: 2
            value: "totals"
        }

        ListElement {
            title: qsTr("Payments")
            sortable: true
            width: 300
            flex: 1
            value: "payments_label"
        }

        ListElement {
            title: qsTr("Date")
            sortable: true
            width: 200
            flex: 1
            value: "created"
        }
    }

    // Components
    DsNewSupplierPopup {
        id: newsupplierpopup
    }

    Requests {
        id: getsalesrequest
        path: "/api/collections/sales_view/records"
    }

    function getSales(txt='') {
        var query = {
            page: pageNo,
            perPage: itemsPerPage,
            sort: `${ sortAsc ? '+' : '-' }${ sortByKey }`,
            filter: `organization='${dsController.organizationID}'` + (txt==='' ? '' : ` && (name ~ '${txt}' || mobile ~ '${txt}' || email ~ '${txt}')`)
        }

        console.log(JSON.stringify(query))
        getsalesrequest.clear()
        getsalesrequest.query = query;
        var res = getsalesrequest.send();

        console.log(res.status)

        if(res.status===200) {
            var data = res.data;
            pageNo=data.page
            totalPages=data.totalPages
            totalItems=data.totalItems
            var items = data.items;

            items.forEach(
                        function(p, index) {
                            p.created =  new Date(p.created).toLocaleString('en-US', {
                                                                                year: 'numeric',
                                                                                month: '2-digit',
                                                                                day: '2-digit',
                                                                                hour: '2-digit',
                                                                                minute: '2-digit'
                                                                            });
                            var payments_methods = []
                            const keys = Object.keys(p.payments)
                            for(var i=0; i<keys.length; i++) {
                                if(p.payments[keys[i]].amount > 0) {
                                    payments_methods.push(p.payments[keys[i]].label.toString())
                                }
                            }

                            var payment_lbl = payments_methods.length === 0 ? "--" : payments_methods.join(', ')
                            p["payments_label"] = payment_lbl
                            items[index] = p
                        });

            datamodel.clear()

            for(var i=0; i<items.length; i++) {
                datamodel.append(items[i])
            }
        }

        else {

        }
    }

    Component.onCompleted: getSales()
}

