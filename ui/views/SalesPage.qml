import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

import "../controls"
import "../popups"

DsPage {
    id: root
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

            onAccepted: getSales()
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
        token: dsController.token
        baseUrl: dsController.baseUrl
        path: "/api/collections/sales_view/records"
    }

    function getSales() {
        var txt = dsSearchInput.text.trim()

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
                toast.warning("Failed to parse response data!");
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

    Component.onCompleted: getSales()

    // Internal Object for holding date states for filtering
    QtObject {
        id: internal

        property string startDateTimeUTC: Qt.formatDateTime(new Date(), "yyyy-MM-dd 00:00:00.000Z")
        property string endDateTimeUTC: Qt.formatDateTime(new Date(), "yyyy-MM-dd 23:59:59.999Z")
        property string selectedDuration: durationSelector.model[durationSelector.currentIndex]

        onSelectedDurationChanged: findStartAndEndDatesInUTC()

        function findStartAndEndDatesInUTC(){
            // durationSelector.close() // Close the popup

            switch(internal.selectedDuration) {
                // Get start and end date & time for 'today' in UTC
            case "Today": {
                var now = new Date() // Current Date & Time

                internal.startDateTimeUTC = Qt.formatDateTime(now, "yyyy-MM-dd 00:00:00.000Z")
                internal.endDateTimeUTC = Qt.formatDateTime(now, "yyyy-MM-dd 23:59:59.999Z")

                salesDateRange = qsTr("Today")
                getSales()

                break;
            }

            // Find start and end date for the current week
            case "This Week": {
                const now = new Date();
                const dayOfWeek = now.getDay(); // 0 (Sunday) to 6 (Saturday)

                // Calculate start and end dates
                const startDate = new Date(now);
                startDate.setDate(now.getDate() - dayOfWeek); // Go back to Sunday

                const endDate = new Date(startDate);
                endDate.setDate(startDate.getDate() + 6); // Add 6 days to get Saturday

                internal.startDateTimeUTC = Qt.formatDateTime(startDate, "yyyy-MM-dd 00:00:00.000Z")
                internal.endDateTimeUTC = Qt.formatDateTime(endDate, "yyyy-MM-dd 23:59:59.999Z")

                salesDateRange = qsTr("This Week")
                getSales()

                break;
            }

            case "Last Week": {
                const now = new Date();
                const dayOfWeek = now.getDay(); // 0 (Sunday) to 6 (Saturday)

                // Calculate the start of the current week
                const currentWeekStart = new Date(now);
                currentWeekStart.setDate(now.getDate() - dayOfWeek);

                // Calculate the start and end dates of last week
                const lastWeekEnd = new Date(currentWeekStart);
                lastWeekEnd.setDate(currentWeekStart.getDate() - 1); // One day before this week's start

                const lastWeekStart = new Date(lastWeekEnd);
                lastWeekStart.setDate(lastWeekEnd.getDate() - 6); // Go back 6 days for the previous week's start

                internal.startDateTimeUTC = Qt.formatDateTime(lastWeekStart, "yyyy-MM-dd 00:00:00.000Z")
                internal.endDateTimeUTC = Qt.formatDateTime(lastWeekEnd, "yyyy-MM-dd 23:59:59.999Z")

                salesDateRange = qsTr("Last Week")
                getSales()

                break;
            }

            // Calculate first and last day of the current month
            case "This Month": {
                let now = new Date()

                // Get current year and month
                var year = now.getUTCFullYear()
                var month = now.getUTCMonth()

                const sd = new Date(year, month, 1);
                const ed = new Date(year, month + 1, 0); // 0th day of the next month = last day of current month

                internal.startDateTimeUTC = Qt.formatDateTime(sd, "yyyy-MM-dd 00:00:00.000Z")
                internal.endDateTimeUTC = Qt.formatDateTime(ed, "yyyy-MM-dd 23:59:59.999Z")

                salesDateRange = qsTr("This Month")
                getSales()

                break;
            }

            // Calculate first and last day of the current month
            case "This Year": {
                let now = new Date()

                // Get current year
                let year = now.getUTCFullYear()

                internal.startDateTimeUTC = `${year}-01-01 00:00:00.000Z`
                internal.endDateTimeUTC = `${year}-12-31 23:59:59.999Z`

                salesDateRange = qsTr("This Year") + `: (${year})`
                getSales()

                break;
            }

            case "Custom":
            default: {
                // Open Custom Date Selector
                daterangeselectorpopup.open()
                salesDateRange = qsTr("Custom") + ": * to *"
            }
            }
        }
    } // QtObject
}

