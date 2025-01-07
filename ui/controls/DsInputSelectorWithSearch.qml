import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import app.digisto.modules

import "../popups"

Rectangle {
    id: control
    radius: Theme.btnRadius
    implicitWidth: 200
    height: col.height + Theme.xsSpacing
    color: Theme.baseAlt1Color

    property string label: qsTr("Input")
    property bool hasError: false
    property bool mandatory: false

    // Collection name/id to do the query from
    required property string collection

    // Alias to the Request
    property alias searchRequest: searchRequest

    // Flag to control selection criteria [single/multiple]
    property bool allowMultipleSelection: true

    // Alias to the search input control
    property alias searchInput: input

    // Model to hold search result data & selected data
    property ListModel dataModel: ListModel{}
    property ListModel searchModel: ListModel{}

    // Fields to be extracted from the model response for display
    property var displayFields: []

    // Control MouseArea control
    MouseArea {
        anchors.fill: parent
        onClicked: {
            // Popup autocloses when we click outside of
            // it, this MouseArea reopens it, lets have a
            // 1s delay before allowing reopening
            if(!popup.closeDelayElapsed) return;

            // Close search popup if already opened
            if(popup.opened) popup.close()

            // Open popup and force active focus on the search input
            else {
                popup.open();
                searchInput.forceActiveFocus()
            }
        }
    }

    // Layout for the control
    Column {
        id: col
        spacing: Theme.xsSpacing
        width: parent.width - 2*Theme.xsSpacing
        anchors.centerIn: parent

        DsLabel {
            text: label
            color: Theme.txtPrimaryColor
            fontSize: Theme.xsFontSize

            DsLabel {
                text: "*"
                isBold: true
                visible: mandatory
                color: Theme.dangerColor
                fontSize: Theme.lgFontSize
                baselineOffset: parent.height
                anchors.baseline: parent.baseline
                anchors.left: parent.right
                anchors.leftMargin: 1
            }
        }

        Flow {
            id: flow
            width: parent.width
            spacing: Theme.xsSpacing

            DsLabel {
                height: Theme.inputHeight
                visible: dataModel.count===0 // Show as placeholder
                text: qsTr("Nothing selected yet!")
                font.pixelSize: Theme.smFontSize
                color: Theme.txtHintColor
                verticalAlignment: DsLabel.AlignVCenter
            }

            Repeater {
                model: control.dataModel
                delegate: Rectangle {
                    color: Theme.baseAlt2Color
                    radius: Theme.btnRadius
                    width: _drow.width
                    height: _drow.height

                    Row {
                        id: _drow
                        spacing: Theme.btnRadius
                        padding: Theme.btnRadius

                        // Label for the selected item
                        DsLabel {
                            text: getDisplayString(model, index)
                            font.pixelSize: Theme.smFontSize
                            color: Theme.txtPrimaryColor
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        // Remove item from model
                        DsIconButton {
                            height: Theme.xsBtnHeight
                            width: height
                            radius: Theme.btnRadius
                            textColor: Theme.dangerColor
                            bgColor: Theme.dangerAltColor
                            bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                            bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                            iconSize: Theme.smFontSize
                            iconType: IconType.x
                            anchors.verticalCenter: parent.verticalCenter

                            onClicked: {
                                dataModel.remove(index)
                            }
                        }
                    }
                }
            }
        }
    }

    DsPopup {
        id: popup
        width: control.width
        height: 300 // _pcol.height + Theme.xsSpacing
        x: 0
        y: control.height - Theme.btnRadius
        borderWidth: 1
        borderColor: Theme.baseAlt1Color

        onClosed: {
            searchModel.clear()
            input.clear()
        }

        contentItem: Item {
            anchors.fill: parent

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.btnRadius
                spacing: Theme.btnRadius

                RowLayout {
                    spacing: Theme.xsSpacing/2
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.btnHeight

                    DsIcon {
                        iconSize: input.font.pixelSize
                        iconType: searchRequest.running ? IconType.loader2 : IconType.search
                        Layout.leftMargin: Theme.xsSpacing
                        Layout.alignment: Qt.AlignVCenter

                        RotationAnimation {
                            target: parent
                            duration: 1000
                            running: searchRequest.running
                            from: 0
                            to: 360
                            loops: RotationAnimation.Infinite

                            onRunningChanged: if(!running) parent.rotation = 0
                        }
                    }

                    TextField {
                        id: input
                        padding: 0
                        width: parent.width - Theme.xsSpacing
                        height: Theme.inputHeight
                        color: Theme.txtPrimaryColor
                        placeholderTextColor: Theme.txtDisabledColor
                        font.pixelSize: Theme.xlFontSize
                        echoMode: TextField.Normal
                        background: Item {}
                        readOnly: searchRequest.running
                        onAccepted: doSearch()


                        Layout.fillWidth: true
                        Layout.rightMargin: Theme.xsSpacing
                    }

                    DsIconButton {
                        radius: height/2
                        visible: input.text !== ""
                        iconSize: input.font.pixelSize
                        iconType: IconType.x
                        textColor: Theme.txtPrimaryColor
                        bgColor: "transparent"
                        enabled: !searchRequest.running
                        bgHover: Theme.dangerAltColor
                        bgDown: withOpacity(Theme.dangerAltColor, 0.8)
                        Layout.rightMargin: Theme.xsSpacing
                        Layout.alignment: Qt.AlignVCenter

                        onClicked: {
                            input.clear()
                            // control.accepted("")
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: Theme.baseAlt1Color
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: searchModel.count === 0

                    DsLabel {
                        text: searchRequest.running ?
                                  qsTr("Loading ...") : // input.text.trim() === "" ?
                                  qsTr("Enter the text and click enter to search")
                        anchors.centerIn: parent
                        fontSize: Theme.baseFontSize
                        color: Theme.txtHintColor
                    }
                }

                ListView {
                    id: searchlv
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    visible: searchModel.count > 0
                    model: control.searchModel
                    spacing: Theme.btnRadius
                    delegate: DsButton {
                        id: _searchdlgt
                        width: searchlv.width
                        height: Theme.btnHeight
                        text: getDisplayString(model, index)
                        textColor: Theme.txtPrimaryColor
                        bgColor: Theme.baseAlt1Color // "transparent"
                        // bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                        // bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                        contentItem: DsLabel {
                            fontSize: _searchdlgt.fontSize
                            color: _searchdlgt.textColor
                            text: _searchdlgt.text
                            elide: DsLabel.ElideRight
                            leftPadding: Theme.xsSpacing
                            rightPadding: Theme.xsSpacing
                            verticalAlignment: DsLabel.AlignVCenter
                        }

                        onClicked: {
                            if(control.allowMultipleSelection) {
                                control.dataModel.append(model)
                            } else {
                                // Clear selection model then append
                                control.dataModel.clear()
                                control.dataModel.append(model)
                            }

                            input.clear()
                            searchModel.clear()
                        }
                    }
                }
            }
        }
    }

    function getDisplayString(model, index) {
        console.log(model, model.count, index)
        // Ensure the index is not greater than model size
        if(index < 0 || index >= model.count) return

        console.log(index)

        if(displayFields.constructor === Array) {
            var data = []
            displayFields.forEach((field) => {
                                      data.push(model[field].toString())
                                  })
            return data.join(" ");

        } else {
            return model[displayFields];
        }
    }

    function doSearch() {
        var txt = input.text.trim()
        var query = {
            page: pageNo,
            perPage: itemsPerPage,
            sort: `${ sortAsc ? '+' : '-' }${ sortByKey }`,
            filter: `organization = '${dsController.organizationID}'` + (txt==='' ? '' : ` && (${buidQuery(txt)})`)
        }

        searchRequest.clear()
        searchRequest.query = query;
        console.log(JSON.stringify(query))
        var res = searchRequest.send();
        console.log(JSON.stringify(res))

        if(res.status===200) {
            var data = res.data;
            pageNo=data.page
            totalPages=data.totalPages
            totalItems=data.totalItems
            var items = data.items;

            control.searchModel.clear()

            data.items.forEach((item) => {
                                   console.log(JSON.stringify(item))
                                   control.searchModel.append(item)
                               })
        }

        else {
            messageBox.showMessage(
                        qsTr("Error fetching data"),
                        `${res.status} - ${res.data.message}`
                        )

        }
    }

    function buidQuery(txt, sep="||") {
        var fields = []
        control.displayFields.forEach((field) => {
                                          fields.push(`${field}~'${txt}'`)
                                      })
        return fields.join(sep)
    }

    DsMessageBox {
        id: messageBox
        z: parent.z
        x: (control.width-width)/2
        y: (control.height-height)/2

        function showMessage(_title, _info) {
            messageBox.title = _title
            messageBox.info = _info
            messageBox.open()
        }
    }

    Requests {
        id: searchRequest
        path: `/api/collections/${control.collection}/records`
    }
}
