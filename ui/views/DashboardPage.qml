import QtQuick
import QtQuick.Layouts
import app.digisto.modules

import "../controls"
import "../js/dashboard.js" as Djs

DsPage {
    id: root
    title: qsTr("Dashboard Page")
    headerShown: false

    // Greeting object; { text: '', icon: ''}
    property var greeting: Djs.getGreeting(mainApp.currentDateTime, IconType)

    // Model to hold last 10 sales data
    property ListModel salesModel: ListModel {}

    // Flag set if there is a running request
    property bool dashboardRequestRunning: fetchSalesTotalsRequest.running ||
                                           fetchCompletedSalesRequest.running ||
                                           fetchStockStatusRequest.running ||
                                           fetchLowStockStatsRequest.running ||
                                           chartCard.fetchSalesDataBusy

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

            Row {
                spacing: Theme.xsSpacing
                Layout.alignment: Qt.AlignBottom

                Column {
                    spacing: Theme.btnRadius
                    // anchors.verticalCenter: parent.verticalCenter

                    DsLabel {
                        color: Theme.txtHintColor
                        fontSize: Theme.baseFontSize
                        text: Qt.formatDateTime(mainApp.currentDateTime, 'hh:mm AP')
                        anchors.right: parent.right
                    }

                    DsLabel {
                        color: Theme.txtPrimaryColor
                        fontSize: Theme.baseFontSize
                        text: Qt.formatDateTime(mainApp.currentDateTime, 'ddd dd MMM, yyyy')
                        anchors.right: parent.right
                    }
                }

                // Reload button
                DsIconButton {
                    busy: root.dashboardRequestRunning
                    iconType: IconType.refresh
                    height: Theme.btnHeight
                    width: height
                    radius: height/2
                    bgColor: Theme.shadowColor
                    iconColor: Theme.txtPrimaryColor
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                    toolTip: qsTr("Reload dashboard data")
                    toolTipSide: DsToolTip.Side.Bottom

                    onClicked: fetchDashboardData()
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

        ListView {
            id: salePillListview

            // Width and Height for the cell delegates
            property real cellWidth: Math.max((width-(spacing*3))/4, 200)
            property real cellHeight: 150

            height: cellHeight // Same as the delegates
            width: parent.width
            spacing: Theme.baseSpacing
            model: globalModels.gridModel
            orientation: ListView.Horizontal
            anchors.horizontalCenter: parent.horizontalCenter
            delegate: DsDashboardPillValue {
                width: salePillListview.cellWidth
                label:              model.label
                value:              model.value
                ref_value:          model.refValue
                deviationShown:     model.deviationShown
                description:        model.description
                trendIconShown:     model.trendIconShown
                periodSelectorShown: model.periodSelectorShown
                deviation:          model.calculateFunc(model.value, model.refValue)

                // Slot connections
                onImplicitHeightChanged: salePillListview.cellHeight = implicitHeight
                onCurrentIndexChanged: function (cindex, lbl) {
                    globalModels.gridModel.setProperty(index, 'period', lbl )
                    fetchDataForPillIndex(index)
                }
            }
        }

        RowLayout {
            width: parent.width
            height: 400
            spacing: Theme.baseSpacing

            property real colWidth: (width-(spacing*3))/4

            DsChartCard {
                id: chartCard
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
            width: parent.width
            height: recentSalesCol.height + Theme.smSpacing

            Column {
                id: recentSalesCol
                width: parent.width
                spacing: Theme.btnRadius
                anchors.centerIn: parent

                property var flexValues: [3, 1, 2, 2]
                property var colWidths: [0,0,0,0]

                onWidthChanged: {
                    var ts = 0
                    flexValues.forEach(v => ts+=v )
                    for(var i=0; i<flexValues.length; i++) {
                        var tw = width - (Theme.btnRadius*(flexValues.length-1))
                        var mult = (flexValues[i] / ts)
                        colWidths[i] = tw * mult
                        console.log(`${i} ${ts} ${mult} ${colWidths[i]}`)
                    }
                    colWidths = colWidths
                }

                // Header labela and sync button
                RowLayout {
                    spacing: Theme.smSpacing
                    width: parent.width - 2*Theme.xsSpacing
                    anchors.horizontalCenter: parent.horizontalCenter

                    DsLabel {
                        text: qsTr("Last 10 Sales")
                        fontSize: Theme.xlFontSize
                        color: Theme.txtHintColor
                        isBold: true
                        elide: DsLabel.ElideRight
                        bottomPadding: Theme.xsSpacing
                        topPadding: Theme.xsSpacing
                        leftPadding: Theme.xsSpacing/2
                        rightPadding: Theme.xsSpacing/2

                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                    }

                    DsLabel {
                        id: syncdateLabel
                        color: Theme.txtHintColor
                        fontSize: Theme.smFontSize
                        text: `Last Sync: ${formatDate}`
                        Layout.alignment: Qt.AlignVCenter

                        property var syncDate: null
                        property string formatDate: syncDate===null ? '--' : Qt.formatDateTime(syncDate, 'hh:mm:ss AP')

                        Connections {
                            target: fetchLast10SalesDataRequest

                            function onRunningChanged() {
                                if(!fetchLast10SalesDataRequest.running) {
                                    syncdateLabel.syncDate = new Date()
                                }
                            }
                        }
                    }

                    // Reload button
                    DsIconButton {
                        busy: fetchLast10SalesDataRequest.running
                        iconType: IconType.refresh
                        height: Theme.btnHeight
                        width: height
                        radius: height/2
                        bgColor: Theme.shadowColor
                        iconColor: Theme.txtPrimaryColor
                        bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                        bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                        toolTip: qsTr("Reload sales")
                        toolTipSide: DsToolTip.Side.Bottom
                        Layout.alignment: Qt.AlignVCenter

                        onClicked: Djs.fetchDashboardLast10Sales(fetchLast10SalesDataRequest, root.salesModel)
                    }
                }

                // Table header
                Rectangle {
                    height: Theme.btnHeight
                    color: Theme.shadowColor
                    width: parent.width

                    RowLayout {
                        spacing: Theme.btnRadius
                        anchors.fill: parent
                        anchors.leftMargin: Theme.xsSpacing
                        anchors.rightMargin: Theme.xsSpacing
                        anchors.horizontalCenter: parent.horizontalCenter

                        DsLabel {
                            text: qsTr('Date')
                            fontSize: Theme.baseFontSize
                            color: Theme.txtPrimaryColor
                            verticalAlignment: DsLabel.AlignVCenter
                            horizontalAlignment: DsLabel.AlignLeft
                            leftPadding: Theme.xsSpacing/2
                            rightPadding: Theme.xsSpacing/2
                            Layout.fillHeight: true
                            Layout.preferredWidth: recentSalesCol.colWidths[0]
                        }

                        DsLabel {
                            text: qsTr('Amount')
                            fontSize: Theme.baseFontSize
                            color: Theme.txtPrimaryColor
                            verticalAlignment: DsLabel.AlignVCenter
                            horizontalAlignment: DsLabel.AlignLeft
                            leftPadding: Theme.xsSpacing/2
                            rightPadding: Theme.xsSpacing/2
                            Layout.fillHeight: true
                            Layout.preferredWidth: recentSalesCol.colWidths[1]
                        }

                        DsLabel {
                            text: qsTr('Teller')
                            fontSize: Theme.baseFontSize
                            color: Theme.txtPrimaryColor
                            verticalAlignment: DsLabel.AlignVCenter
                            horizontalAlignment: DsLabel.AlignLeft
                            leftPadding: Theme.xsSpacing/2
                            rightPadding: Theme.xsSpacing/2
                            Layout.fillHeight: true
                            Layout.preferredWidth: recentSalesCol.colWidths[2]
                        }

                        DsLabel {
                            text: qsTr("Payments")
                            fontSize: Theme.baseFontSize
                            color: Theme.txtPrimaryColor
                            verticalAlignment: DsLabel.AlignVCenter
                            horizontalAlignment: DsLabel.AlignLeft
                            leftPadding: Theme.xsSpacing/2
                            rightPadding: Theme.xsSpacing/2
                            Layout.fillHeight: true
                            Layout.preferredWidth: recentSalesCol.colWidths[3]
                        }
                    }

                }

                Item {
                    height: 100
                    width: parent.width
                    visible: root.salesModel.count === 0

                    DsLabel {
                        text: qsTr("Nothing here yet!")
                        fontSize: Theme.xlFontSize
                        color: Theme.txtHintColor
                        isBold: true
                        elide: DsLabel.ElideRight
                        bottomPadding: Theme.xsSpacing
                        topPadding: Theme.xsSpacing
                        anchors.centerIn: parent
                    }
                }

                Repeater {
                    id: rp
                    width: parent.width
                    model: salesModel
                    delegate: Rectangle {
                        color: hovered ? withOpacity(Theme.baseAlt1Color, 0.8) : Theme.baseColor
                        height: Theme.btnHeight
                        width: recentSalesCol.width

                        property bool hovered: false

                        // Bottom margin line
                        Rectangle {
                            height: 1
                            width: parent.width
                            color: Theme.shadowColor
                            anchors.bottom: parent.bottom
                        }

                        // Top margin line
                        Rectangle {
                            height: 1
                            width: parent.width
                            visible: index === 0
                            color: Theme.shadowColor
                            anchors.top: parent.top
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.hovered=true
                            onExited: parent.hovered=false
                        }

                        RowLayout {
                            spacing: Theme.btnRadius
                            anchors.fill: parent
                            anchors.leftMargin: Theme.xsSpacing
                            anchors.rightMargin: Theme.xsSpacing
                            anchors.horizontalCenter: parent.horizontalCenter

                            DsLabel {
                                text: model.date
                                fontSize: Theme.baseFontSize
                                color: Theme.txtPrimaryColor
                                verticalAlignment: DsLabel.AlignVCenter
                                horizontalAlignment: DsLabel.AlignLeft
                                leftPadding: Theme.xsSpacing/2
                                rightPadding: Theme.xsSpacing/2
                                Layout.fillHeight: true
                                Layout.preferredWidth: recentSalesCol.colWidths[0]
                            }

                            DsLabel {
                                text: `${dsController.organization.settings.currency.toUpperCase()} ${model.totals}`
                                fontSize: Theme.baseFontSize
                                color: Theme.txtPrimaryColor
                                verticalAlignment: DsLabel.AlignVCenter
                                horizontalAlignment: DsLabel.AlignLeft
                                leftPadding: Theme.xsSpacing/2
                                rightPadding: Theme.xsSpacing/2
                                Layout.fillHeight: true
                                Layout.preferredWidth: recentSalesCol.colWidths[1]
                            }

                            DsLabel {
                                text: (model.teller && model.teller!=='') ? model.teller : qsTr('N/A')
                                fontSize: Theme.baseFontSize
                                color: Theme.txtPrimaryColor
                                verticalAlignment: DsLabel.AlignVCenter
                                horizontalAlignment: DsLabel.AlignLeft
                                leftPadding: Theme.xsSpacing/2
                                rightPadding: Theme.xsSpacing/2
                                Layout.fillHeight: true
                                Layout.preferredWidth: recentSalesCol.colWidths[2]
                            }

                            DsLabel {
                                text: model.payments
                                fontSize: Theme.baseFontSize
                                color: Theme.txtPrimaryColor
                                verticalAlignment: DsLabel.AlignVCenter
                                horizontalAlignment: DsLabel.AlignLeft
                                leftPadding: Theme.xsSpacing/2
                                rightPadding: Theme.xsSpacing/2
                                Layout.fillHeight: true
                                Layout.preferredWidth: recentSalesCol.colWidths[3]
                            }
                        }
                    }
                }
            }
        }
    }

    // --------------------------------------- //
    // REQUEST Objects                         //
    // --------------------------------------- //
    Requests {
        id: fetchSalesTotalsRequest
        token: dsController.token
        baseUrl: dsController.baseUrl
    }

    Requests {
        id: fetchCompletedSalesRequest
        token: dsController.token
        baseUrl: dsController.baseUrl
    }

    Requests {
        id: fetchStockStatusRequest
        token: dsController.token
        baseUrl: dsController.baseUrl
    }

    Requests {
        id: fetchLowStockStatsRequest
        token: dsController.token
        baseUrl: dsController.baseUrl
    }

    Requests {
        id: fetchLast10SalesDataRequest
        token: dsController.token
        baseUrl: dsController.baseUrl
        path: "/api/collections/sales_view/records"
    }

    // ------------------------------------------------------- //

    function fetchDataForPillIndex(index) {
        switch(index) {
        case 0: { // Total Sales
            Djs.fetchDashboardTotalSalesSum(fetchSalesTotalsRequest,    globalModels.gridModel)
            break;
        }

        case 1: { // Number of Sales
            Djs.fetchDashboardCompletedSales(fetchCompletedSalesRequest, globalModels.gridModel)
            break;
        }

        case 2: { // Stock Status
            Djs.fetchDashboardStockStatus(fetchStockStatusRequest,      globalModels.gridModel)
            break;
        }

        case 3: { // Low Stock Products
            Djs.fetchDashboardLowStockStats(fetchLowStockStatsRequest,  globalModels.gridModel)
            break;
        }
        }
    }

    // Fetch all dashboard data
    function fetchDashboardData() {
        Djs.fetchDashboardTotalSalesSum(fetchSalesTotalsRequest,        globalModels.gridModel)
        Djs.fetchDashboardCompletedSales(fetchCompletedSalesRequest,    globalModels.gridModel)
        Djs.fetchDashboardStockStatus(fetchStockStatusRequest,          globalModels.gridModel)
        Djs.fetchDashboardLowStockStats(fetchLowStockStatsRequest,      globalModels.gridModel)
        Djs.fetchDashboardLast10Sales(fetchLast10SalesDataRequest,      root.salesModel)
    }

    Timer {
        id: fetchDataTimer
        interval: 2000
        repeat: false
        onTriggered: fetchDashboardData()
    }

    // ------------------------------------------ //
    // On Completed, Do ...                       //
    // ------------------------------------------ //
    Component.onCompleted: {
        fetchDataTimer.restart()    // Restart the timer
    }
}
