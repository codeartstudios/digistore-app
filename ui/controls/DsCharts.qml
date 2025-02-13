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

    // Chart x/y-axis legend
    property var xAxisLabels
    property var yAxisData

    onXAxisLabelsChanged: {
        canvasBars.chartData.labels = xAxisLabels
        canvasBars.requestPaint()

    }
    onYAxisDataChanged: {
        canvasBars.chartData.datasets[0].data = yAxisData
        canvasBars.requestPaint()
    }

    property alias chart: canvasBars

    Chart {
        id: canvasBars
        chartType: "bar"
        animationEasingType: Easing.Linear
        animationDuration: 200
        anchors.fill: parent


        chartData: { return {
                labels: ['-','-','-','-','-','-','-','-'],
                datasets: [
                    {
                        label: 'Sales Data',
                        backgroundColor: Theme.warningAltColor, // '#ff9999',
                        stack: 'Stack 0',
                        data: [0,0,0,0,0,0,0,0]
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
                            position: 'bottom',
                            id: 'x-axis-1'
                        }],
                    yAxes: [{
                            stacked: true,
                            display: true,
                            position: 'left',
                            id: 'y-axis-1',
                            ticks: {
                                min: 0
                            }
                        }]
                }
            }
        }
    }
}
