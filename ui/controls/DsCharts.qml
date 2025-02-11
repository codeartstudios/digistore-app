import QtQuick
import app.digisto.modules

import "../chartjs"

Item {
    id: root

    function randomScalingFactor() {
        return Math.random().toFixed(1);
    }

    property bool chartTitleShown: true
    property string chartTitle: qsTr("Sales Data")

    // Chart x-axis legend
    property var xAxisLabels: ['January', 'February', 'March', 'April', 'May', 'June', 'July']
    property var yAxisData: [
        randomScalingFactor(),
        randomScalingFactor(),
        randomScalingFactor(),
        randomScalingFactor(),
        randomScalingFactor(),
        randomScalingFactor(),
        randomScalingFactor()
    ]

    Chart {
        id: canvasBars
        chartType: "bar"
        anchors.fill: parent

        chartData: { return {
                labels: root.xAxisLabels,
                datasets: [
                    {
                        label: 'Sales Data',
                        backgroundColor: Theme.warningAltColor, // '#ff9999',
                        stack: 'Stack 0',
                        data: root.yAxisData
                    }
                ]
            }
        }

        chartOptions: {
            return {
                maintainAspectRatio: false,
                title: {
                    display: root.chartTitleShown,
                    text: root.chartTitle
                },
                tooltips: {
                    mode: 'index',
                    intersect: false
                },
                responsive: true,
                scales: {
                    xAxes: [{
                            stacked: true,
                        }],
                    yAxes: [{
                            stacked: true
                        }]
                }
            }
        }
    }
}
