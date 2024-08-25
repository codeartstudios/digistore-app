import QtQuick
import app.digisto.modules

import "../controls"

DsPage {
    id: dashboardPage
    title: qsTr("Dashboard Page")
    headerShown: false

    // Top pills


    // Item {
    //     width: parent.width
    //     height: Theme.lgBtnHeight

    //     Rectangle {
    //         width: parent.width
    //         height: 1
    //         color: Theme.baseAlt2Color
    //         anchors.bottom: parent.bottom
    //     }

    //     Row {
    //         spacing: Theme.xsSpacing
    //         anchors.verticalCenter: parent.verticalCenter

    //         DsLabel {
    //             text: qsTr("Dashboard")
    //             fontSize: Theme.h1
    //             leftPadding: Theme.baseSpacing
    //         }
    //     }
    // }


    Column {
        spacing: Theme.baseSpacing
        anchors.fill: parent
        anchors.margins: Theme.xlSpacing

        Row {
            spacing: Theme.baseSpacing
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            DsDashboardPillValue {
                width: (parent.width-(parent.spacing*3))/4
                label: qsTr("Branches")
                value: qsTr("4")
                units: qsTr("")
            }

            DsDashboardPillValue {
                width: (parent.width-(parent.spacing*3))/4
                label: qsTr("Users")
                value: qsTr("23")
                units: qsTr("")
            }

            DsDashboardPillValue {
                width: (parent.width-(parent.spacing*3))/4
                label: qsTr("Sale")
                value: qsTr("234")
                units: qsTr("")
            }

            DsDashboardPillValue {
                width: (parent.width-(parent.spacing*3))/4
                label: qsTr("Stock")
                value: qsTr("48")
                units: qsTr("")
            }

        }

        Row {
            width: parent.width
            spacing: Theme.baseSpacing

            Rectangle {
                height: 300
                radius: Theme.btnRadius
                width: parent.spacing + 2*(parent.width-(parent.spacing*3))/4
                color: Theme.baseColor
                border.width: 1
                border.color: Theme.baseAlt1Color
            }

            Rectangle {
                height: 300
                radius: Theme.btnRadius
                width: (parent.width-(parent.spacing*3))/4
                color: Theme.baseColor
                border.width: 1
                border.color: Theme.baseAlt1Color
            }

            Rectangle {
                height: 300
                radius: Theme.btnRadius
                width: (parent.width-(parent.spacing*3))/4
                color: Theme.baseColor
                border.width: 1
                border.color: Theme.baseAlt1Color
            }
        }
    }
}
