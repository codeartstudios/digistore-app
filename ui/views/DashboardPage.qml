import QtQuick
import QtQuick.Layouts
import app.digisto.modules

import "../controls"

DsPage {
    id: root
    title: qsTr("Dashboard Page")
    headerShown: false

    property var currentDateTime: new Date()
    property var greeting: getGreeting(currentDateTime)
    property ListModel salesModel: ListModel {}
    property ListModel gridModel: ListModel {}

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

        ListView {
            id: salePillListview

            // Width and Height for the cell delegates
            property real cellWidth: Math.max((width-(spacing*3))/4, 200)
            property real cellHeight: 150

            height: cellHeight // Same as the delegates
            width: parent.width
            spacing: Theme.baseSpacing
            model: root.gridModel   //
            orientation: ListView.Horizontal
            anchors.horizontalCenter: parent.horizontalCenter
            delegate: DsDashboardPillValue {
                width: salePillListview.cellWidth
                label: model.label
                value: model.value
                deviation: getDeviation(model.value, model.refValue)
                deviationShown: Utils.isNullOrUndefined(model.deviationShown) ? true : model.deviationShown
                description: model.description
                trendIconShown: true // Utils.isNullOrUndefined(model.trendIconShown) ? true : model.trendIconShown
                // TODO, fix above

                onImplicitHeightChanged: salePillListview.cellHeight = implicitHeight
                onCurrentIndexChanged: (cindex, lbl) => {
                                           root.gridModel.setProperty(index, 'period', lbl )
                                           fetchDataForPillIndex(index)
                                       }

                function getDeviation(_new, _old) {
                    if(_old===null) return 0

                    // Set the mode value
                    mode = _old===_new ? DsDashboardPillValue.Mode.FLAT :
                                         _new > _old ? DsDashboardPillValue.Mode.UP :
                                                       DsDashboardPillValue.Mode.DOWN

                    // Catch wh
                    if(_old === _new && _old === 0) return 0

                    // Calculate deviation
                    var devt = 0
                    if(_old===0)
                        devt = _new * 100   // We can't divide by 0
                    else
                        devt = (_new - _old)/_old * 100

                    // Return deviation percentage
                    return devt%1 === 0 ? devt : devt.toFixed(1)
                }
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

    function getGreeting(date) {
        var hours = date.getHours()
        if(hours < 12)
            return { text: qsTr("Good Morning"), icon : IconType.sunset2}
        else if(hours < 16)
            return { text: qsTr("Good Afternoon"), icon : IconType.sun}
        else
            return { text: qsTr("Good Evening"), icon : IconType.moonStars}
    }

    Component.onCompleted: {
        // Populate the gridModel with default data
        gridModel.clear()   // Reset model if we have any data
        gridModel.append({
                             period: '7days',
                             label: qsTr("Total Sales"),
                             description: qsTr("Revenue generated within the selected period"),
                             refValue: 0,
                             value: 0
                         })

        gridModel.append({
                             period: '7days',
                             label: qsTr("No. of Sales"),
                             description: qsTr("Sales transactions completed"),
                             refValue: 0,
                             value: 0
                         })

        gridModel.append({
                             period: '7days',
                             label: qsTr("Stock Status"),
                             description: qsTr("Current stock available for sale"),
                             refValue: 12,
                             value: 22,
                             trendIconShown: false
                         })

        gridModel.append({
                             period: '7days',
                             label: qsTr("Low Stock Products"),
                             description: qsTr("Number of products with critically low stock"),
                             value: 0
                         })

        // Fetch total sale amount for selected period
        fetchDashboardTotalSalesSum()
    }

    function fetchDataForPillIndex(index) {
        switch(index) {
        case 0: { // Total Sales
            fetchDashboardTotalSalesSum()
            break;
        }

        case 1: { // Number of Sales
            fetchDashboardCompletedSales()
            break;
        }

        case 2: { // Stock Status
            fetchDashboardStockStatus()
            break;
        }

        case 3: { // Low Stock Products
            fetchDashboardLowStockStats()
            break;
        }
        }
    }

    function fetchDashboardCompletedSales() {
        // fetchCompletedSalesRequest
    }

    function fetchDashboardStockStatus() {
        // fetchStockStatusRequest
    }

    function fetchDashboardLowStockStats() {

    }

    function fetchDashboardTotalSalesSum() {
        const totalSales = root.gridModel.get(0) // Fetch model at index 0

        // Fetch current and previous date cycle. i.e, past 7 days and 7 days before that
        var date = null
        if(totalSales.period === '3months')
            date = Utils.last3MonthsDates()

        else if(totalSales.period === '30days')
            date = Utils.last30DaysDates()

        else // 7days
            date = Utils.last7DaysDates()

        // Format date
        const currentDateCycleStart = Qt.formatDateTime(date.current, "yyyy-MM-dd 00:00:00.000Z")
        const previousDateCycleStart = Qt.formatDateTime(date.previous, "yyyy-MM-dd 00:00:00.000Z")
        const endpoint = `${dsController.workspaceId}/${previousDateCycleStart}/${currentDateCycleStart}`

        // Create and send GET request
        fetchSalesTotalsRequest.clear()
        fetchSalesTotalsRequest.path = `/fn/dashboard/total-sales/${endpoint}`
        var res = fetchSalesTotalsRequest.send();

        if(res.status===200) {
            var data = res.data;
            root.gridModel.setProperty(0, 'refValue', data.old_value)
            root.gridModel.setProperty(0, 'value', data.value)
        }

        else {
            toast.error(res.data.message)
        }
    }
}
