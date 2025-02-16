import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import app.digisto.modules

DsInputWithLabel {
    id: root
    validator: IntValidator{ bottom: 100000000 }
    inputRL.spacing: Theme.xsSpacing/2
    secondaryActionLabel.text: qsTr("Clear")
    secondaryActionLabel.visible: !(selectedCountry===null && input.text.trim()==='')

    onSecondaryAction: {
        selectedCountry=null
        input.text=''
    }

    onSelectedCountryChanged: {
        if(selectedCountry && input.text==='') {
            input.forceActiveFocus()
        }
    }

    beforeItem: [
        DsButton {
            id: countryselectbtn
            height: Theme.inputHeight
            bgColor: "transparent"
            text: selectedCountry ? selectedCountry[displayField] : "+--"
            textColor: selectedCountry ? Theme.txtPrimaryColor : Theme.txtDisabledColor
            bgHover: withOpacity(Theme.baseAlt2Color, 0.8)
            bgDown: withOpacity(Theme.baseAlt2Color, 0.6)
            endIcon: IconType.caretUpDownFilled
            contentRow.spacing: Theme.xsSpacing/2

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
    ]

    DsPopup {
        id: popup
        width: root.width
        height: 250
        x: 0
        y: root.height - Theme.btnRadius
        borderWidth: 1
        borderColor: Theme.baseAlt1Color

        onOpened: filterByCountryOrByCode()

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
                        id: ico
                        iconSize: searchInput.font.pixelSize
                        iconType: IconType.search
                        Layout.leftMargin: Theme.xsSpacing
                        Layout.alignment: Qt.AlignVCenter
                    }

                    TextField {
                        id: searchInput
                        padding: 0
                        width: parent.width - Theme.xsSpacing
                        height: Theme.inputHeight
                        color: Theme.txtPrimaryColor
                        placeholderTextColor: Theme.txtDisabledColor
                        font.pixelSize: Theme.xlFontSize
                        echoMode: TextField.Normal
                        placeholderText: qsTr("Country name or dial code")
                        background: Item {}
                        onTextChanged: filterByCountryOrByCode()
                        Component.onCompleted: filterByCountryOrByCode()


                        Layout.fillWidth: true
                        Layout.rightMargin: Theme.xsSpacing
                    }

                    DsIconButton {
                        radius: height/2
                        visible: searchInput.text !== ""
                        iconSize: searchInput.font.pixelSize
                        iconType: IconType.x
                        textColor: Theme.txtPrimaryColor
                        bgColor: "transparent"
                        bgHover: Theme.dangerAltColor
                        bgDown: withOpacity(Theme.dangerAltColor, 0.8)
                        Layout.rightMargin: Theme.xsSpacing
                        Layout.alignment: Qt.AlignVCenter

                        onClicked: { searchInput.clear() }
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
                        width: parent.width * 0.6
                        text: qsTr("We didn't find anything matching your search!")
                        fontSize: Theme.baseFontSize
                        color: Theme.txtHintColor
                        wrapMode: DsLabel.WordWrap
                        horizontalAlignment: DsLabel.AlignHCenter
                        anchors.centerIn: parent
                    }
                }

                ListView {
                    id: searchlv
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    clip: true
                    visible: searchModel.count > 0
                    model: root.searchModel
                    spacing: Theme.btnRadius
                    delegate: DsButton {
                        id: _searchdlgt
                        width: searchlv.width
                        height: Theme.btnHeight
                        text: `[${model.dial_code}] ${model.name} (${model.code})`
                        textColor: Theme.txtPrimaryColor
                        bgColor: (selectedCountry && selectedCountry.dial_code === model.dial_code) ? Theme.successAltColor : Theme.baseAlt1Color

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
                            // Clear selection model then append
                            root.selectedCountry = {
                                code: model.code,
                                name: model.name,
                                dial_code: model.dial_code
                            }

                            popup.close()
                            searchInput.clear()
                        }
                    }
                }
            }
        }
    }

    function filterByCountryOrByCode() {
        var searchKey = searchInput.text.trim();
        searchModel.clear()
        if(searchKey==="") {
            StaticModels.worldMobileModel.forEach((country) => {
                                     searchModel.append(country)
                                 })
        } else {
            StaticModels.worldMobileModel.forEach((country) => {
                                     if(country.name.toLowerCase().includes(searchKey) ||
                                        country.dial_code.toLowerCase().includes(searchKey) ||
                                        country.code.toLowerCase().includes(searchKey)) {
                                         searchModel.append(country)
                                     }
                                 })
        }
    }

    function clear() {
        selectedCountry = null
        input.clear()
    }

    // Convenience function to select by dial code
    function findAndSetCountryByDialCode(dialCode) {
        findAndSetCountryBy('dial_code', dialCode)
    }

    // Expects 2 args, the model `key`, and `value` to be checked
    // optionally, allows providing the compare function, by default is null
    //          compareFunc(modelValue, filterValue)
    // Example:
    //      findAndSetCountryBy('dial_code', '+254', (modelValue, value) => modelValue.includes(value))
    function findAndSetCountryBy(key, value, compareFunc = null) {
        for(var i=0; i<StaticModels.worldMobileModel.length; i++) {
            var country = StaticModels.worldMobileModel[i]
            if(compareFunc) {
                if(compareFunc(country[key],value)) {
                    selectedCountry = country
                    break
                }
            }

            else{
                if(country[key] === value) {
                    selectedCountry = country
                    break
                }
            }
        }
    }

    property string displayField: "dial_code"
    property var selectedCountry: null
    property ListModel searchModel: ListModel{}

}
