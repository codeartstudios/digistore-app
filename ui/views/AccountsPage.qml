import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

import "../controls"
import "../popups"

DsPage {
    id: root
    title: "Accounts Page"
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
                visible: durationSelector.currentIndex === durationSelector.model.length - 1
                enabled: !getsalesrequest.running
                iconType: IconType.edit
                textColor: Theme.txtPrimaryColor
                bgColor: "transparent"
                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                radius: height/2
                Layout.alignment: Qt.AlignVCenter

                // TODO pass current date as input to the popup
                onClicked: daterangeselectorpopup.open()
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

            DsDateRangeSelector {
                id: durationSelector
                enabled: !getsalesrequest.running
                model: ["Today", "This Week", "Last Week", "This Month", "This Year", "Custom"]
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
            id: salestable
            Layout.fillWidth: true
            Layout.fillHeight: true
            headerModel: headermodel
            dataModel: datamodel
            busy: getsalesrequest.running
            pageNo: root.pageNo - 1
            itemsPerPage: root.itemsPerPage

            onSortBy: function(key) {
                if(key===sortByKey) {
                    sortAsc = !sortAsc;
                } else {
                    sortAsc = true;
                }

                sortByKey = key;

                getSales()
            }

            // When current selected index changes, get the sales data
            // at given index and pass it to the drawer
            onCurrentIndexChanged: {
                // Open drawer only if current index is valid
                if( currentIndex >= 0 ) {
                    saleDrawer.dataModel = dataModel.get(currentIndex);
                    saleDrawer.open();
                } else {
                    // Close Drawer if already opened
                    if( saleDrawer.opened ) saleDrawer.close()
                }
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

    // Popup to show date selection for custom
    // date range selection
    DsSalesCustomDateSelectorPopup {
        id: daterangeselectorpopup

        onClosed: datamodel.clear() // Clear current items

        onRangeSelected: {
            // Update internal dates for filters
            internal.startDateTimeUTC = Utils.dateToUTC(filterStartDate, "zero")
            internal.endDateTimeUTC = Utils.dateToUTC(filterEndDate, "max")

            // Update the top label string
            salesDateRange = qsTr("Custom") +
                    `: (${Qt.formatDateTime(filterStartDate, "yyyy-MM-dd hh:mm ap")}) to (${Qt.formatDateTime(filterEndDate, "yyyy-MM-dd hh:mm ap")})`

            // Close popup before fetching the sales data
            daterangeselectorpopup.close()
            getSales()
        }
    }

    // Drawer to display selected sales item from the table
    DsSelectedSaleProductsDrawer {
        id: saleDrawer

        // Reset table current index when the drawer closes
        onClosed: salestable.currentIndex = -1
    }

    Requests {
        id: getsalesrequest
        path: "/api/collections/sales_view/records"
    }

    function getSales(txt='') {
        var dateQuery = `created >= '${internal.startDateTimeUTC}' && created <= '${internal.endDateTimeUTC}'`
        var query = {
            page: pageNo,
            perPage: itemsPerPage,
            sort: `${ sortAsc ? '+' : '-' }${ sortByKey }`,
            filter: `organization='${dsController.workspaceId}'`
                    + (txt==='' ? '' : ` && (total ~ '${txt}' || payments ~ '${txt}' || created ~ '${txt}')`)
                    + ` && ${dateQuery}`
        }

        // console.log(JSON.stringify(query))

        getsalesrequest.clear()
        getsalesrequest.query = query;
        var res = getsalesrequest.send();

        // console.log(res, JSON.stringify(res))

        if(res.status===200) {
            var data = res.data;
            pageNo=data.page
            totalPages=data.totalPages
            totalItems=data.totalItems
            var items = data.items;

            try {
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
            }
            catch(err) {
                console.log("Sales Page: ", err)
            }

            datamodel.clear()

            for(var i=0; i<items.length; i++) {
                datamodel.append(items[i])
            }
        }

        else if(res.status === 0) {
            showMessage(
                        qsTr("Connection Refused"),
                        qsTr("Could not connect to the server, something is'nt right!")
                        )
        }

        else if(res.status === 403) {
            showMessage(
                        qsTr("Authentication Error"),
                        qsTr("You don't seem to have access rights to perform this action.")
                        )
        }

        else {
            showMessage(
                        qsTr("Error Occured"),
                        res.message ? res.message : qsTr("Yuck! Something not right here!")
                        )
        }
    }

    Component.onCompleted: {}
}

