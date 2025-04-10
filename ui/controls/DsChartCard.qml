import QtQuick
import QtQuick.Layouts
import app.digisto.modules

// TODO
// today = 2AM local time
// Make a sale, check sales for today, empty!
// How to reconcile books
Rectangle {
    id: root
    radius: Theme.btnRadius
    color: Theme.baseColor
    border.width: 1
    border.color: Theme.shadowColor

    property string label: qsTr("Sales summary")
    property bool isProcessingData: false
    property bool fetchSalesDataBusy: fetchSalesChartRequest.running || isProcessingData

    ColumnLayout {
        id: col
        spacing: Theme.xsSpacing
        anchors.fill: parent
        anchors.margins: Theme.xsSpacing

        // Label and period dropdown selection
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.xsSpacing

            DsLabel {
                text: root.label
                fontSize: Theme.xlFontSize
                height: Theme.btnHeight
                color: Theme.txtHintColor
                isBold: true
                elide: DsLabel.ElideRight
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }

            DsDashboardPillSelector {
                id: pillSelector
                model: [qsTr("Last 7 Days"), qsTr("Last 30 Days"), qsTr("Last 3 Months")]
                onCurrentIndexChanged: onDurationChanged()
            }
        }

        DsCharts {
            id: salesChart
            Layout.fillWidth: true
            Layout.fillHeight: true

            function loadTableData() {
                const today = new Date();
                const date = new Date();
                date.setDate(today.getDate() - 6); // 7 days ago
                var xdata = Utils.last7Days()
                salesChart.xAxisLabels = xdata
                salesChart.yAxisData = Array(xdata.length).fill(0);
                salesChart.chart.animateToNewData();
            }

            Component.onCompleted: loadTableData()
        }
    }

    // Repopulate the x-axis model
    function onDurationChanged() {
        var today = new Date()

        switch(pillSelector.currentIndex) {
        case 0: {
            const date = new Date();
            date.setDate(today.getDate() - 6); // 7 days ago

            var xdata = Utils.last7Days()
            salesChart.xAxisLabels = xdata
            salesChart.yAxisData = Array(xdata.length).fill(0);

            fetchSalesDataFromDate(date, xdata.length)
            break
        }

        case 1: {
            const date = new Date();
            date.setDate(today.getDate() - 29); // 30 days ago

            xdata= Utils.last30Days()
            salesChart.xAxisLabels = xdata
            salesChart.yAxisData = Array(xdata.length).fill(0);

            fetchSalesDataFromDate(date, xdata.length)
            break
        }

        case 2: {
            const startDate = new Date();
            startDate.setMonth(today.getMonth() - 3); // Start from 3 months ago

            xdata= Utils.last3Months()
            salesChart.xAxisLabels = xdata
            salesChart.yAxisData = Array(xdata.length).fill(0);

            fetchSalesDataFromDate(startDate, xdata.length)
            break
        }
        }

        salesChart.chart.animateToNewData();
    }

    function fetchSalesDataFromDate(date, count) {
        // Check if date is valid
        if(!date) {
            toast.error(qsTr('Date provided for sales range is invalid!'))
            return
        }

        // Convert to UTC, midnght string
        var startDateUTC = Utils.startDateUTC(date)

        var query = {
            perPage: 1000000,
            sort: '+created',
            filter: `organization = '${dsController.workspaceId}' && created >= '${startDateUTC}'`,
            skipTotal: true,
            fields: 'created,totals'
        }

        fetchSalesChartRequest.clear()
        fetchSalesChartRequest.query = query;
        var res = fetchSalesChartRequest.send();

        if(res.status===200) {
            var data = res.data;
            var items = data.items;

            processDataFor('salesChart', items, date, count)
        }

        else {
            showMessage(
                        qsTr("Error fetching sales data"),
                        `${toErrorString(res)}`
                        )
        }
    }

    Requests {
        id: fetchSalesChartRequest
        baseUrl: dsController.baseUrl
        token: dsController.token
        path: '/api/collections/sales/records'
    }

    // Iterate over each API data and generate y-data for the chart
    function processDataFor(type, apiData, startDate, numDays=0) {
        isProcessingData = true // Processing Starts

        const yData = Array(numDays).fill(0); // Initialize array with zeros

        // Ensure we zero to the start of the day to avoid -ve values for the same day
        const start = new Date(Utils.startDateUTC(startDate))

        if(type==='salesChart') {
            apiData.forEach(
                        entry => {
                            const createdDate = new Date(entry.created); // Parse UTC created date
                            if(createdDate) {
                                const diffDays = Math.floor((createdDate - start) / (1000 * 60 * 60 * 24)); // Days from start

                                if (diffDays >= 0 && diffDays < numDays) {
                                    yData[diffDays] += entry.totals; // Sum totals for the same day
                                }
                            }
                        });
        }

        salesChart.yAxisData = yData

        isProcessingData = false // Processing Ends
    }

    // ----------------------------------------------------------------------- //

    Timer {
        id: fetchChartTimer
        repeat: false
        interval: 2000
        onTriggered: if(dsPermissionManager.canViewSales) onDurationChanged()
    }

    Component.onCompleted: fetchChartTimer.restart()
}
