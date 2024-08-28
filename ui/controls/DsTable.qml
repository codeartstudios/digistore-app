import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

Rectangle {
    id: root
    color: Theme.bodyColor

    required property ListModel headerModel
    required property ListModel dataModel

    property string headerAcionIconType: IconType.dots
    property string delegateActionIconType: IconType.dots

    property alias listView: listview

    // Delegate properties
    property bool alternatingRowColors: true

    property bool busy: false

    // When any column header is clicked
    signal sortSelected(var index)

    // When the action button on the header is selected
    signal headerActionButtonSelected
    signal delegateActionButtonSelected(var index, var data)

    // Sort by a specific column
    signal sortBy(var col)

    property bool hscrollbarShown: false
    property alias hscrollbar: hscrollbar

    ScrollBar {
        id: hscrollbar
        z: 11
        policy: hscrollbarShown ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
        active: hovered || pressed
        hoverEnabled: true
        orientation: Qt.Horizontal
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }

    ListView {
        id: listview

        property var columnWidths: []
        property real headerWidth: 70
        property real footerWidth: 70

        clip: true
        model: dataModel
        headerPositioning: ListView.OverlayHeader
        anchors.fill: parent

        ScrollBar.vertical: ScrollBar{ policy: ScrollBar.AsNeeded }
        ScrollBar.horizontal: ScrollBar{ policy: ScrollBar.AlwaysOff }

        header: Item {
            id: tableheader
            z: 3
            width: listView.width
            height: 50
            clip: true

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

                ScrollView {
                    id: c_sv
                    z: 1
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    ScrollBar.horizontal: ScrollBar{ policy: ScrollBar.AlwaysOff }
                    ScrollBar.vertical: ScrollBar{ policy: ScrollBar.AlwaysOff }

                    onContentWidthChanged: root.hscrollbarShown = c_sv.contentWidth > c_sv.width

                    Binding {
                        target: hscrollbar
                        property: "size"
                        value: c_sv.contentWidth>c_sv.width ? c_sv.width/c_sv.contentWidth : 1
                    }

                    Connections {
                        target: hscrollbar

                        function onPositionChanged() {
                            var newContentX = hscrollbar.position * (c_sv.contentWidth - c_sv.width);
                            c_sv.contentItem.contentX = newContentX
                        }
                    }

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

        delegate: Rectangle {
            id: tabledelegate
            width: listview.width
            height: 50
            color: ma.pressed ? bgDown : ma.hovered ? bgHover : root.color

            property string bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
            property string bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

            property var rowModel: model    // Model data for the current delegate
            property var rowIndex: index    // Row index assigned

            MouseArea {
                id: ma
                anchors.fill: parent
                hoverEnabled: true
                onEntered: ma.hovered=true
                onExited: ma.hovered=false
                property bool hovered: false
            }

            RowLayout {
                spacing: 0
                anchors.fill: parent

                Rectangle {
                    z: 10
                    color: ma.pressed ? bgDown : ma.hovered ? bgHover : root.color
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
                        text: `${tabledelegate.rowIndex + 1}.`
                        verticalAlignment: DsLabel.AlignVCenter
                        horizontalAlignment: DsLabel.AlignLeft
                        anchors.right: parent.right
                    }
                }

                ScrollView {
                    id: tablerowscrollview
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ScrollBar.horizontal: ScrollBar{ policy: ScrollBar.AlwaysOff }
                    ScrollBar.vertical: ScrollBar{ policy: ScrollBar.AlwaysOff }

                    Connections {
                        target: hscrollbar

                        function onPositionChanged() {
                            var newContentX = hscrollbar.position * (tablerowscrollview.contentWidth - tablerowscrollview.width);
                            tablerowscrollview.contentItem.contentX = newContentX
                        }
                    }

                    Row {
                        height: tabledelegate.height

                        Repeater {
                            model: headerModel

                            delegate: Item {
                                height: tabledelegate.height
                                width: listview.columnWidths[index]

                                Connections {
                                    target: listview

                                    function onColumnWidthsChanged() {
                                        width = listview.columnWidths[index]
                                    }
                                }

                                DsLabel {
                                    elide: DsLabel.ElideRight
                                    fontSize: Theme.smFontSize
                                    text: tabledelegate.rowModel[value]==="" ? "--" : tabledelegate.rowModel[value]
                                    verticalAlignment: DsLabel.AlignVCenter
                                    leftPadding: Theme.smSpacing
                                    rightPadding: Theme.smSpacing
                                    anchors.fill: parent
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    z: 10
                    color: ma.pressed ? bgDown : ma.hovered ? bgHover : root.color
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
