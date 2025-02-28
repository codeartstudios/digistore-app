import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.qmlmodels
import app.digisto.modules

Rectangle {
    id: root
    color: Theme.bodyColor

    required property ListModel headerModel
    required property ListModel dataModel

    property string headerAcionIconType: IconType.dots
    property string delegateActionIconType: IconType.dots

    property bool accessAllowed: false
    property string accessDeniedText: qsTr("You don't have access to this view, please contact the organization Admin for assistance.")
    property string blankDisplayText: qsTr("This view seems to be empty, please reload or try adding some new data!")
    property string busyDisplayText: qsTr("Hold on, we are feching this data for you.")

    property alias listView: listview
    property alias currentIndex: listview.currentIndex

    // Delegate properties
    property bool alternatingRowColors: true
    property bool busy: false

    // When any column header is clicked
    signal sortSelected(var index)
    signal selectionChanged(var index, var model)

    // When the action button on the header is selected
    signal headerActionButtonSelected
    signal delegateActionButtonSelected(var index, var data)

    // Sort by a specific column
    signal sortBy(var col)

    property bool hscrollbarShown: false

    // Hold a reference to the count of items nin the response
    // model: itemsPerPage & pageNo
    property real pageNo: 0
    property real itemsPerPage: 0

    Item {
        id: tableheader
        z: 3
        width: listView.width
        height: 50
        clip: true
        anchors.top: parent.top

        // Bind width changes to column width recalculation
        onWidthChanged: calculateWidthChanges();

        Connections {
            target: headerModel

            function onCountChanged() {
                calculateWidthChanges();
            }
        }

        RowLayout {
            spacing: 0
            anchors.fill: parent

            Rectangle {
                color: root.color
                z: 10
                Layout.fillHeight: true
                Layout.preferredWidth: listview.headerWidth

                Rectangle {
                    height: 1
                    color: Theme.baseAlt2Color
                    width: parent.width
                    anchors.bottom: parent.bottom
                }

                DsBusyIndicator {
                    width: 50
                    height: 50
                    iconSize: 20
                    running: busy
                    visible: running
                    anchors.right: parent.right
                }

                DsLabel {
                    width: 35
                    height: 50
                    text: "#"
                    visible: !busy
                    color: Theme.txtHintColor
                    fontWeight: Font.DemiBold
                    font.pixelSize: Theme.xlFontSize
                    verticalAlignment: DsLabel.AlignVCenter
                    anchors.right: parent.right
                }
            }

            // Removed Scrollview
            Item {
                id: c_sv
                z: 1
                Layout.fillHeight: true
                Layout.fillWidth: true

                Row {
                    height: tableheader.height

                    Repeater {
                        model: headerModel
                        delegate: DsTableHeaderButton {
                            text: title
                            height: tableheader.height
                            sortable: sortable
                            width: listview.columnWidths.length===0 ? 0 : listview.columnWidths[index]
                            font.pixelSize: Theme.xlFontSize

                            onClicked: root.sortBy(value)
                        }
                    }
                }
            }

            Rectangle {
                color: root.color
                z: 10
                Layout.fillHeight: true
                Layout.preferredWidth: listview.footerWidth

                Rectangle {
                    height: 1
                    color: Theme.baseAlt2Color
                    width: parent.width
                    anchors.bottom: parent.bottom
                }

                DsIconButton {
                    bgColor: "transparent"
                    width: 50
                    height: 50
                    iconType: headerAcionIconType
                    textColor: Theme.txtHintColor
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: root.headerActionButtonSelected()
                }
            }
        }

        Rectangle {
            height: 1
            width: parent.width
            color: Theme.baseAlt2Color
            anchors.bottom: parent.bottom
        }
    }

    Item {
        visible: dataModel.count === 0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: tableheader.bottom
        
        Column {
            spacing: Theme.smSpacing
            width: parent.width * 0.5
            anchors.centerIn: parent

            DsIcon {
                iconSize: Theme.lgBtnHeight
                iconColor: Theme.txtHintColor
                iconType: busy ? IconType.clock : !accessAllowed ?
                                     IconType.shieldExclamation :
                                     IconType.folderExclamation
                anchors.horizontalCenter: parent.horizontalCenter
            }

            DsLabel {
                width: parent.width
                wrapMode: DsLabel.WordWrap
                color: Theme.txtHintColor
                fontSize: Theme.baseFontSize
                horizontalAlignment: DsLabel.AlignHCenter
                text: busy ? busyDisplayText : !accessAllowed ?
                                 accessDeniedText : blankDisplayText
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    ListView {
        id: listview

        property var columnWidths: []
        property real headerWidth: 70
        property real footerWidth: 70

        clip: true
        model: dataModel
        currentIndex: -1
        visible: dataModel.count > 0
        headerPositioning: ListView.OverlayHeader
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: tableheader.bottom

        ScrollBar.vertical: ScrollBar{ policy: ScrollBar.AsNeeded }
        ScrollBar.horizontal: ScrollBar{ policy: ScrollBar.AlwaysOff }

        delegate: Rectangle {
            id: tabledelegate
            width: listview.width
            height: 50
            color: selected ? selectedColor : ma.pressed ? bgDown : ma.hovered ? bgHover : root.color

            property string bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
            property string bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
            property string selectedColor: withOpacity(Theme.baseAlt1Color)

            property var rowModel: model    // Model data for the current delegate
            property int rowIndex: index    // Row index assigned
            property bool selected: listview.currentIndex===index

            MouseArea {
                id: ma
                anchors.fill: parent
                hoverEnabled: true
                onEntered: ma.hovered=true
                onExited: ma.hovered=false
                property bool hovered: false

                onClicked: {
                    listview.currentIndex=index
                    root.selectionChanged(tabledelegate.rowIndex, tabledelegate.rowModel)
                }
            }

            RowLayout {
                spacing: 0
                anchors.fill: parent

                Rectangle {
                    z: 10
                    color: selected ? tabledelegate.selectedColor : ma.pressed ? bgDown : ma.hovered ? bgHover : root.color
                    Layout.fillHeight: true
                    Layout.preferredWidth: listview.headerWidth

                    property string bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    property string bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                    Rectangle {
                        height: 1
                        color: Theme.baseAlt2Color
                        width: parent.width
                        anchors.bottom: parent.bottom
                    }

                    DsLabel {
                        width: 35
                        height: 50
                        elide: DsLabel.ElideRight
                        fontSize: Theme.smFontSize
                        text: `${ pageNo * itemsPerPage + (tabledelegate.rowIndex + 1)}.`
                        verticalAlignment: DsLabel.AlignVCenter
                        horizontalAlignment: DsLabel.AlignLeft
                        anchors.right: parent.right
                    }
                }

                Row {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Repeater {
                        model: headerModel

                        delegate: Item {
                            height: tabledelegate.height
                            width: listview.columnWidths[index]

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: ma.hovered=true
                                onExited: ma.hovered=false
                                onClicked: (e) => ma.clicked(e)
                            }

                            Connections {
                                target: listview

                                function onColumnWidthsChanged() {
                                    width = listview.columnWidths[index]
                                }
                            }

                            DsLabel {
                                property var val: value.split('.').reduce((acc, key) => acc && acc[key], tabledelegate.rowModel)
                                elide: DsLabel.ElideRight
                                fontSize: Theme.smFontSize
                                text: !val || val==="" ? "N/A" : getDisplayString(val)
                                verticalAlignment: DsLabel.AlignVCenter
                                leftPadding: Theme.smSpacing
                                rightPadding: Theme.smSpacing
                                anchors.fill: parent

                                function getDisplayString(data) {
                                    if(model.formatBy) {
                                        return model.formatBy(data)
                                    }

                                    return data
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    z: 10
                    color: selected ? tabledelegate.selectedColor : ma.pressed ? bgDown : ma.hovered ? bgHover : root.color
                    Layout.fillHeight: true
                    Layout.preferredWidth: listview.footerWidth

                    property string bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    property string bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                    DsIconButton {
                        bgColor: "transparent"
                        width: 50
                        height: 50
                        iconType: delegateActionIconType
                        textColor: Theme.txtHintColor
                        bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                        bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: root.delegateActionButtonSelected(tabledelegate.rowIndex, tabledelegate.rowModel)
                    }

                    Rectangle {
                        height: 1
                        color: Theme.baseAlt2Color
                        width: parent.width
                        anchors.bottom: parent.bottom
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Theme.baseAlt2Color
                anchors.bottom: parent.bottom
            }
        }
    }

    function populateColumnWidths() {
        var newcolwidths=[]     // Hold new width values

        for(var i=0; i<headerModel.count; i++) {
            newcolwidths.push(headerModel.get(i).width)
        }

        listview.columnWidths = newcolwidths
    }

    function calculateWidthChanges() {
        var colswidthsum=0, nonflexwidthsum=0, flexsum=0;
        var workingWidth = listview.width - (listview.headerWidth + listview.footerWidth)

        for(var i=0; i<headerModel.count; i++) {
            var item = headerModel.get(i)
            flexsum += item["flex"];
            colswidthsum += item["width"];
            if(item["flex"]===0)
                nonflexwidthsum+=item["width"]
        }

        if(colswidthsum < listview.width) {
            var newcolwidths = []
            workingWidth -= colswidthsum

            for(let i=0; i<headerModel.count; i++) {
                let item = headerModel.get(i)
                var flex = item["flex"];
                var baseWidth = item["width"];
                var newWidth = flex===0 ? baseWidth : baseWidth + (workingWidth * flex/flexsum)
                newcolwidths.push(newWidth)
            }

            listview.columnWidths = newcolwidths
        }

        else {
            let newcolwidths = []
            for(let i=0; i<headerModel.count; i++) {
                newcolwidths.push(headerModel.get(i).width)
            }
            listview.columnWidths = newcolwidths
        }
    }
}
