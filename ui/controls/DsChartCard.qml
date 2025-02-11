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
                onCurrentIndexChanged: durationChanged()
            }
        }

        DsCharts {
            id: salesChart
            Layout.fillWidth: true
            Layout.fillHeight: true

            Component.onCompleted: durationChanged()
        }
    }

    // Repopulate the x-axis model
    function durationChanged() {
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
            salesChart.xAxisLabels = Utils.last30Days()
            const date = new Date();
            date.setDate(today.getDate() - 29); // 30 days ago
            xdata= Utils.last7Days()
            salesChart.xAxisLabels = xdata
            salesChart.yAxisData = Array(xdata.length).fill(0);
            fetchSalesDataFromDate(date, xdata.length)
            break
        }
        case 2: {
            salesChart.xAxisLabels = Utils.last3Months()
            const startDate = new Date();
            startDate.setMonth(today.getMonth() - 2); // Start from 3 months ago
            xdata= Utils.last7Days()
            salesChart.xAxisLabels = xdata
            salesChart.yAxisData = Array(xdata.length).fill(0);
            fetchSalesDataFromDate(date, xdata.length)
            break
        }
        }
    }

    function fetchSalesDataFromDate(date, count) {
        // Check if date is valid
        if(!date) {
            toast.error(qsTr('Date provided for sales range is invalid!'))
            return
        }

        // Convert to UTC, midnght string
        var startDateUTC = Qt.formatDateTime(date, 'yyyy-MM-dd 00:00:00.0Z')

        var query = {
            perPage: 100000,
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
                        `${res.data.message}`
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
    function processDataFor(type, apiData, start, numDays=0) {
        const yData = Array(numDays).fill(0); // Initialize array with zeros

        if(type==='salesChart') {
            apiData.forEach(entry => {
                                const createdDate = new Date(entry.created); // Parse UTC created date
                                const diffDays = Math.floor((createdDate - start) / (1000 * 60 * 60 * 24)); // Days from start

                                if (diffDays >= 0 && diffDays < numDays) {
                                    yData[diffDays] += entry.totals; // Sum totals for the same day
                                }
                            });
        }

        salesChart.yAxisData = yData
    }
}
