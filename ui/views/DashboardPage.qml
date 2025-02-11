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
                value: `${Utils.commafy(model.value)}`
                deviation: getDeviation(model)
                deviationShown: model.refValue ? true : false
                description: model.description
                trendIconShown: model.trendIconShown!==null ? model.trendIconShown : deviationShown

                onImplicitHeightChanged: salePillListview.cellHeight = implicitHeight

                function getDeviation(_) {
                    if(!model.refValue) return 0

                    var _old = model.refValue, _new = model.value;

                    // Set the mode value
                    mode = _old===_new ? DsDashboardPillValue.Mode.FLAT :
                                         _new > _old ? DsDashboardPillValue.Mode.UP :
                                                       DsDashboardPillValue.Mode.DOWN

                    // Calculate deviation
                    var devt = (_new - _old)/_old * 100

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
        _get_()

        // Populate the gridModel with default data
        gridModel.clear()   // Reset model if we have any data
        gridModel.append({
                             label: qsTr("Total Sales"),
                             description: qsTr("Revenue generated within the selected period"),
                             refValue: 0,
                             value: 0
                         })

        gridModel.append({
                             label: qsTr("No. of Sales"),
                             description: qsTr("Sales transactions completed"),
                             refValue: 0,
                             value: 0
                         })

        gridModel.append({
                             label: qsTr("Stock Status"),
                             description: qsTr("Current stock available for sale"),
                             refValue: 12,
                             value: 22,
                             trendIconShown: false
                         })

        gridModel.append({
                             label: qsTr("Low Stock Products"),
                             description: qsTr("Number of products with critically low stock"),
                             value: 0
                         })

        console.log('Model appended ...: ', gridModel.count)
    }

    // Fetch total sales
    Requests {
        id: fetchSalesTotalsRequest
        token: dsController.token
        baseUrl: dsController.baseUrl
        path: "/fn/dashboard/total-sales"
    }

    function getProducts() {
        var txt = dsSearchInput.text.trim()
        var query = {
            page: pageNo,
            perPage: itemsPerPage,
            sort: `${ sortAsc ? '+' : '-' }${ sortByKey }`,
            filter: `organization = '${dsController.workspaceId}'` + (txt==='' ? '' : ` && (name ~ '${txt}' || unit ~ '${txt}' || barcode ~ '${txt}')`)
        }

        getproductrequest.clear()
        getproductrequest.query = query;
        var res = getproductrequest.send();

        if(res.status===200) {
            var data = res.data;
            pageNo=data.page
            totalPages=data.totalPages
            totalItems=data.totalItems
            var items = data.items;

            datamodel.clear()

            // Workaround to get tags:['str'] extractable later
            for(var i=0; i<items.length; i++) {
                var tags = []
                var obj = items[i]
                if(!obj.tags) obj.tags = []
                obj.tags.forEach((tag) => {
                                     tags.push({ data: tag })
                                 })
                obj.tags = tags
                datamodel.append(obj)
            }
        }

        else {
            showMessage(
                        qsTr("Error fetching products"),
                        qsTr("There was an issue when fetching products: ") + `[${res.status}]${res.data.message}`
                        )
        }
    }

}
