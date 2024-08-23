import QtQuick

Rectangle {
    id: root
    color: theme.baseColor

    required property ListModel headerModel
    required property ListModel dataModel
    property alias listView: listview

    // Delegate properties
    property bool alternatingRowColors: true

    // When any column header is clicked
    signal sortSelected(var index)

    // When the checkbox on header item is checked/unchecked
    signal checkAllChanged(bool checked)

    // When the action button on the header is selected
    signal actionSelected()

    onHeaderModelChanged: {
        var newcolwidths=[]     // Hold new width values

        for(var i=0; i<headerModel.count; i++) {
            newcolwidths.push(headerModel.get(i).width)
        }

        listview.columnWidths = newcolwidths
    }


    ListView {
        id: listview

        property var columnWidths: []

        clip: true
        model: dataModel
        headerPositioning: ListView.OverlayHeader
        anchors.fill: parent
        anchors.topMargin: theme.baseSpacing

        header: Item {
            z: 3
            width: listView.width
            height: 50
            clip: true

            onWidthChanged: logWidth()
            Component.onCompleted: logWidth()
            function logWidth() { console.log(`Widths: header[${width}], listview[${listview.width}], root[${root.implicitWidth}]`) }

            Rectangle {
                height: 1
                width: parent.width
                color: theme.baseAlt2Color
                anchors.bottom: parent.bottom
            }

            ListView {
                id: headerlv
                height: parent.height
                anchors.left: parent.left
                anchors.right: parent.right
                model: headerModel
                boundsBehavior: Flickable.StopAtBounds
                orientation: ListView.Horizontal
                headerPositioning: ListView.OverlayHeader
                footerPositioning: ListView.OverlayFooter

                delegate: DsTableHeaderButton {
                    text: model.title
                    height: 50
                    sortable: model.sortable
                    width: listview.columnWidths.length===0 ? 0 : listview.columnWidths[index]
                    font.weight: 600
                    font.pixelSize: theme.xlFontSize
                }

                header: Rectangle {
                    height: 50
                    width: 70
                    color: root.color
                    z: 10

                    Rectangle {
                        height: 1
                        color: theme.baseAlt2Color
                        width: parent.width
                        anchors.bottom: parent.bottom
                    }

                    DsCheckBox {
                        width: 50
                        height: 50
                        boxSize: 24
                        checked: false
                        anchors.right: parent.right
                    }
                }

                footer: Rectangle {
                    height: 50
                    width: 70
                    color: root.color
                    z: 10

                    Rectangle {
                        height: 1
                        color: theme.baseAlt2Color
                        width: parent.width
                        anchors.bottom: parent.bottom
                    }

                    DsIconButton {
                        bgColor: "transparent"
                        width: 50
                        height: 50
                        iconType: dsIconType.dots
                        textColor: theme.txtHintColor
                        bgHover: withOpacity(theme.baseAlt1Color, 0.8)
                        bgDown: withOpacity(theme.baseAlt1Color, 0.6)

                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: root.actionSelected()
                    }
                }

                // Bind width changes to column width recalculation
                onWidthChanged: calculateWidthChanges();
                Component.onCompleted: calculateWidthChanges();

                function calculateWidthChanges() {
                    var colswidthsum=0, nonflexwidthsum=0, flexsum=0;
                    var workingWidth = listview.width - (headerlv.headerItem.width + headerlv.footerItem.width)

                    for(var i=0; i<headerModel.count; i++) {
                        var item = headerModel.get(i)
                        flexsum += item["flex"];
                        colswidthsum += item["width"];
                        if(item["flex"]===0)
                            nonflexwidthsum+=item["width"]
                    }

                    if(colswidthsum < headerlv.width) {
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
        }
    }
}
