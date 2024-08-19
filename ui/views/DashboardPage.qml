import QtQuick

import "../controls"

DsPage {
    id: dashboardPage
    title: qsTr("Dashboard Page")
    headerShown: false

    // Top pills


    // Item {
    //     width: parent.width
    //     height: theme.lgBtnHeight

    //     Rectangle {
    //         width: parent.width
    //         height: 1
    //         color: theme.baseAlt2Color
    //         anchors.bottom: parent.bottom
    //     }

    //     Row {
    //         spacing: theme.xsSpacing
    //         anchors.verticalCenter: parent.verticalCenter

    //         DsLabel {
    //             text: qsTr("Dashboard")
    //             fontSize: theme.h1
    //             leftPadding: theme.baseSpacing
    //         }
    //     }
    // }


    Column {
        spacing: theme.baseSpacing
        anchors.fill: parent
        anchors.margins: theme.xlSpacing

        Row {
            spacing: theme.baseSpacing
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
            spacing: theme.baseSpacing

            Rectangle {
                height: 300
                radius: theme.btnRadius
                width: parent.spacing + 2*(parent.width-(parent.spacing*3))/4
                color: theme.baseColor
                border.width: 1
                border.color: theme.baseAlt1Color
            }

            Rectangle {
                height: 300
                radius: theme.btnRadius
                width: (parent.width-(parent.spacing*3))/4
                color: theme.baseColor
                border.width: 1
                border.color: theme.baseAlt1Color
            }

            Rectangle {
                height: 300
                radius: theme.btnRadius
                width: (parent.width-(parent.spacing*3))/4
                color: theme.baseColor
                border.width: 1
                border.color: theme.baseAlt1Color
            }
        }


    }
}
