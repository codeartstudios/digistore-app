import QtQuick
import QtQuick.Layouts
import app.digisto.modules

import "../controls"

DsPage {
    id: dashboardPage
    title: qsTr("Dashboard Page")
    headerShown: false

    property var currentDateTime: new Date()
    property var greeting: getGreeting(currentDateTime)
    property ListModel salesModel: ListModel {}

    function getGreeting(date) {
        var hours = date.getHours()
        if(hours < 12)
            return { text: qsTr("Good Morning"), icon : IconType.sunset2}
        else if(hours < 16)
            return { text: qsTr("Good Afternoon"), icon : IconType.sun}
        else
            return { text: qsTr("Good Evening"), icon : IconType.moonStars}
    }

    DsSettingsStackPage {
        spacing: Theme.baseSpacing
        anchors.fill: parent
        anchors.topMargin: Theme.smSpacing
        anchors.bottomMargin: Theme.xlSpacing
        columnHorizontalMargin: Theme.xlSpacing

        // Greeting, quick action
        RowLayout {
            spacing: Theme.baseSpacing
            width: parent.width

            Column {
                spacing: Theme.xsSpacing/2
                Layout.fillWidth: true

                DsLabel {
                    fontSize: Theme.h1
                    color: Theme.txtHintColor
                    text: qsTr("Dashboard")
                }

                Row {
                    spacing: Theme.btnRadius

                    DsIcon {
                        iconSize: Theme.baseFontSize
                        iconType: greeting.icon
                        iconColor: Theme.txtHintColor
                        anchors.bottom: parent.bottom
                    }

                    DsLabel {
                        color: Theme.txtPrimaryColor
                        fontSize: Theme.baseFontSize
                        text: `${greeting.text}, ${dsController.loggedUser.name.split(' ')[0]}`
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        Rectangle {
            id: announcementBar
            color: Theme.warningAltColor
            height: Math.max(Theme.lgBtnHeight, msgcol.height + Theme.xsSpacing*2)
            width: parent.width
            radius: Theme.btnRadius

            property string message: "Some funky message"
            property string buttonText: qsTr("Check it out!")

            // Visibility flags
            property bool announcementBarShown: true
            property bool actionButtonShown: true
            property bool closeButtonShown: true

            signal closeClicked()
            signal actionClicked()

            RowLayout {
                spacing: Theme.xsSpacing
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Theme.xsSpacing
                anchors.rightMargin: Theme.xsSpacing
                anchors.verticalCenter: parent.verticalCenter

                Column {
                    id: msgcol
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter

                    DsLabel {
                        text: announcementBar.message
                        color: Theme.primaryColor
                        width: parent.width
                        fontSize: Theme.baseFontSize

                        wrapMode: DsLabel.WordWrap
                    }
                }

                DsButton {
                    text: announcementBar.buttonText
                    endIcon: IconType.arrowUpRight
                    bgColor: Theme.warningColor
                    textColor: Theme.baseColor
                    visible: announcementBar.actionButtonShown
                    Layout.alignment: Qt.AlignVCenter

                    onClicked: announcementBar.actionClicked()
                }

                DsIconButton {
                    iconType: IconType.x
                    radius: height/2
                    width: Theme.btnHeight
                    height: Theme.btnHeight
                    textColor: Theme.dangerColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.dangerAltColor, 0.8)
                    bgDown: withOpacity(Theme.dangerAltColor, 0.8)
                    visible: announcementBar.closeButtonShown
                    Layout.alignment: Qt.AlignVCenter

                    onClicked: announcementBar.closeClicked()
                }
            }
        }

        Row {
            spacing: Theme.baseSpacing
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            DsDashboardPillValue {
                width: (parent.width-(parent.spacing*3))/4
                label: qsTr("Sales")
                value: `${Utils.commafy(4325)}`
            }

            DsDashboardPillValue {
                width: (parent.width-(parent.spacing*3))/4
                label: qsTr("Sales")
                value: `${Utils.commafy(4325)}`
                deviation: 0
                mode: DsDashboardPillValue.Mode.FLAT
            }

            DsDashboardPillValue {
                width: (parent.width-(parent.spacing*3))/4
                label: qsTr("Sales")
                value: `${Utils.commafy(12)}`
                deviation: 4
                mode: DsDashboardPillValue.Mode.DOWN
            }

            DsDashboardPillValue {
                width: (parent.width-(parent.spacing*3))/4
                label: qsTr("Sales")
                value: `${Utils.commafy(432)}`
                deviation: 63
                mode: DsDashboardPillValue.Mode.UP
            }

        }

        RowLayout {
            width: parent.width
            height: 400
            spacing: Theme.baseSpacing

            property real colWidth: (width-(spacing*3))/4

            DsChartCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            DsDashboardQuickLinks {
                Layout.preferredWidth: parent.colWidth
                Layout.fillHeight: true
            }
        }

        Rectangle {
            radius: Theme.btnRadius
            color: Theme.baseColor
            border.width: 1
            border.color: Theme.shadowColor
            Layout.fillWidth: true
            Layout.fillHeight: true
            Column {
                anchors.fill: parent
                anchors.margins: Theme.xsSpacing
                spacing: Theme.btnRadius

                DsLabel {
                    width: parent.width
                    text: qsTr("Last 10 Sales")
                    fontSize: Theme.xlFontSize
                    height: Theme.btnHeight
                    color: Theme.txtHintColor
                    isBold: true
                    elide: DsLabel.ElideRight
                    bottomPadding: Theme.xsSpacing
                }

                Repeater {
                    id: rp
                    width: parent.width
                    model: salesModel
                    delegate: RowLayout {
                        width: rp.width
                        spacing: Theme.btnRadius

                        DsLabel {
                            text: name
                        }
                    }
                }
            }
        }
    }
}
