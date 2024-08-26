import QtQuick
import app.digisto.modules

Rectangle {
    id: root
    color: Theme.bodyColor

    required property ListModel headerModel
    required property ListModel dataModel
    property alias listView: listview

    // Delegate properties
    property bool alternatingRowColors: true

    property bool busy: false

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

    // TODO handle table toggles
    function headerCheckToggled(checked) {
        if(checked) {
            for(var i=0; i<dataModel.count; i++) {

            }
        }
    }


    ListView {
        id: listview

        property var columnWidths: []

        clip: true
        model: dataModel
        headerPositioning: ListView.OverlayHeader
        anchors.fill: parent
        // anchors.topMargin: Theme.baseSpacing

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
                color: Theme.baseAlt2Color
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
                    font.pixelSize: Theme.xlFontSize
                }

                header: Rectangle {
                    height: 50
                    width: 70
                    color: root.color
                    z: 10

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

                    DsCheckBox {
                        width: 50
                        height: 50
                        boxSize: 24
                        checked: false
                        visible: !busy
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
                        color: Theme.baseAlt2Color
                        width: parent.width
                        anchors.bottom: parent.bottom
                    }

                    DsIconButton {
                        bgColor: "transparent"
                        width: 50
                        height: 50
                        iconType: IconType.dots
                        textColor: Theme.txtHintColor
                        bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                        bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

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

            ListView {
                id: delegatelv
                clip: true
                height: parent.height
                anchors.left: parent.left
                anchors.right: parent.right
                model: headerModel
                boundsBehavior: Flickable.StopAtBounds
                orientation: ListView.Horizontal
                headerPositioning: ListView.OverlayHeader
                footerPositioning: ListView.OverlayFooter

                header: Rectangle {
                    height: 50
                    width: 70
                    z: 10
                    color: ma.pressed ? bgDown : ma.hovered ? bgHover : root.color

                    property string bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    property string bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                    Rectangle {
                        height: 1
                        color: Theme.baseAlt2Color
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
                    z: 10
                    color: ma.pressed ? bgDown : ma.hovered ? bgHover : root.color

                    property string bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    property string bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

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
                        iconType: IconType.dots
                        textColor: Theme.txtHintColor
                        bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                        bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: root.actionSelected()
                    }
                }

                delegate: Item {
                    height: delegatelv.height
                    width: listview.columnWidths[index]

                    DsLabel {
                        anchors.fill: parent
                        verticalAlignment: DsLabel.AlignVCenter
                        leftPadding: Theme.smSpacing
                        rightPadding: Theme.smSpacing
                        elide: DsLabel.ElideRight
                        fontSize: Theme.smFontSize
                        text: tabledelegate.rowModel[model.value]
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
}
