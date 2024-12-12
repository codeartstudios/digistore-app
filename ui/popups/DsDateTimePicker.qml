import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.platform
import app.digisto.modules

import "../controls"

Popup {
    id: root
    width: 500
    height: 400 + 2*Theme.smSpacing
    modal: true
    x: (mainApp.width-width)/2
    y: (mainApp.height-height)/2
    closePolicy: Popup.NoAutoClose

    property var selectedDate: new Date()
    property int minimumYear: 2000
    property int maximumYear: new Date().getFullYear()

    property var yearsModel: []

    signal dateSelected()   // Emitted when popup is accepted

    onMinimumYearChanged: fillYearModel()
    onMaximumYearChanged: fillYearModel()

    onOpened: {
        if(selectedDate.getFullYear() > maximumYear) selectedDate.setFullYear(maximumYear)
        monthcb.currentIndex = selectedDate.getMonth()

        for(var i=0; i<yearsModel; i++) {
            if(yearsModel[i]===selectedDate.getFullYear()) {
                yearcb.currentIndex = i;
                break;
            }
        }
    }

    function fillYearModel() {
        var years = []

        if(maximumYear < minimumYear) {
            var m = maximumYear;
            maximumYear = minimumYear
            minimumYear = m
        }

        for(var y=maximumYear; y>=minimumYear; y--) {
            years.push(y);
        }

        yearsModel = years;
    }

    background: Rectangle {
        color: Theme.bodyColor
        radius: Theme.btnRadius
    }

    contentItem: Item {
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.smSpacing

            Row {
                spacing: Theme.xsSpacing

                Layout.fillWidth: true
                Layout.preferredHeight: Theme.btnHeight

                RowLayout {
                    width: parent.width
                    height: Theme.btnHeight
                    spacing: Theme.xsSpacing

                    // Year selection combobox
                    DsComboBox {
                        id: yearcb
                        model: yearsModel
                        popupHeight: monthgrid.height
                        onCurrentValueChanged: monthgrid.year = currentValue
                    }

                    //Month selection Combobox
                    DsComboBox {
                        id: monthcb
                        popupHeight: monthgrid.height
                        model: ["January", 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
                        onCurrentIndexChanged: monthgrid.month = currentIndex
                    }

                    // Select Time Button
                    // TODO Add dropdown icon
                    DsButton {
                        bgColor: "transparent"
                        textColor: Theme.txtPrimaryColor
                        bgHover: Qt.lighter(Theme.baseAlt1Color, 0.8)
                        bgDown: Qt.lighter(Theme.baseAlt1Color, 0.6)
                        height: Theme.btnHeight
                        text: Qt.formatTime(selectedDate, "hh:mm") + qsTr(" hrs")

                        onClicked: timeselctorpopup.open()
                    }

                    // Close Popup Button
                    DsIconButton {
                        iconType: IconType.x
                        textColor: Theme.txtPrimaryColor
                        bgColor: "transparent"
                        bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                        bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                        radius: height/2
                        Layout.alignment: Qt.AlignVCenter

                        onClicked: root.close()
                    }
                }
            }

            DayOfWeekRow {
                Layout.column: 1
                Layout.fillWidth: true

                delegate: DsButton {
                    width: Theme.smBtnHeight
                    height: Theme.btnHeight
                    text: shortName
                    fontSize: Theme.smFontSize
                    opacity: enabled ? 1 : 1
                    enabled: false
                    bgColor: "transparent"
                    bgHover: "transparent"
                    bgDown: "transparent"
                    textColor: Theme.txtPrimaryColor

                    required property string shortName
                }
            }

            MonthGrid {
                id: monthgrid
                month: Calendar.December
                year: 2024
                locale: Qt.locale("en_US")

                Layout.fillWidth: true
                Layout.fillHeight: true

                onClicked: (dt) => {
                               var sdt = selectedDate
                               sdt.setFullYear(dt.getFullYear())
                               sdt.setMonth(dt.getMonth())
                               sdt.setDate(dt.getDate())
                               selectedDate = sdt
                           }

                delegate: DsButton {
                    enabled: model.year >= minimumYear && model.year <= maximumYear
                    width: Theme.smBtnHeight
                    height: Theme.btnHeight
                    opacity: model.month === monthgrid.month ? 1 : enabled ? 0.5 : 0.1
                    text: model.day
                    fontSize: Theme.smFontSize
                    bgColor: isSelectedDate ? Theme.baseAlt4Color : Theme.baseAlt1Color
                    textColor: Theme.txtPrimaryColor

                    onClicked: monthgrid.clicked(new Date(model.year, model.month, model.day));

                    required property var model
                    property bool isSelectedDate
                    isSelectedDate: model.year===root.selectedDate.getFullYear()
                                    && model.month===root.selectedDate.getMonth()
                                    && model.day===root.selectedDate.getDate()
                }
            }

            Rectangle {
                color: Theme.baseAlt3Color

                Layout.topMargin: Theme.xsSpacing
                Layout.bottomMargin: Theme.xsSpacing
                Layout.fillWidth: true
                Layout.preferredHeight: 1
            }

            RowLayout {
                spacing: Theme.xsSpacing
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.smBtnHeight

                DsLabel {
                    text: Qt.formatDateTime(selectedDate, "ddd, MMMM dd, yyyy, hh:mm") + qsTr(" hrs")
                    color: Theme.txtPrimaryColor
                    height: Theme.smBtnHeight
                    verticalAlignment: DsLabel.AlignVCenter
                    fontSize: Theme.baseFontSize

                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                }

                // Set the current selected date/time back to
                // the caller
                DsButton {
                    bgColor: Theme.primaryColor
                    height: Theme.smBtnHeight
                    text: qsTr("Select")

                    onClicked: {
                        dateSelected()  // Emit date selected signal
                        root.close()    // Close the popup
                    }
                }
            }
        }
    }

    // Time Selection Popup
    Popup {
        id: timeselctorpopup
        width: 250
        height: 300
        modal: true
        x: (root.width-width)/2
        y: (root.height-height)/2
        closePolicy: Popup.NoAutoClose

        // When popup is opened, upate the hour/minutes tumblers
        // with the values from the selectedDate property
        onOpened: {
            hoursTumbler.currentIndex = root.selectedDate.getHours()
            minutesTumbler.currentIndex = root.selectedDate.getMinutes()
        }

        background: Rectangle {
            color: Theme.bodyColor
            radius: Theme.btnRadius
        }

        contentItem: Item {
            anchors.fill: parent

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.xsSpacing

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Component {
                        id: delegateComponent

                        DsLabel {
                            text: formatText(Tumbler.tumbler.count, modelData)
                            opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: Theme.baseFontSize

                            function formatText(count, modelData) {
                                var data = count === 12 ? modelData + 1 : modelData;
                                return data.toString().length < 2 ? "0" + data : data;
                            }
                        }
                    }

                    Tumbler {
                        id: hoursTumbler
                        model: 24
                        delegate: delegateComponent
                    }

                    DsLabel {
                        text: ":"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Theme.xlFontSize
                    }

                    Tumbler {
                        id: minutesTumbler
                        model: 60
                        delegate: delegateComponent
                    }

                    DsLabel {
                        text: hoursTumbler.currentIndex < 12 ? qsTr("AM") : qsTr("PM")
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Theme.baseFontSize
                    }
                }

                Row {
                    spacing: Theme.xsSpacing
                    Layout.alignment: Qt.AlignRight
                    Layout.preferredHeight: Theme.smBtnHeight

                    // Close Popup Buttton
                    DsButton {
                        bgColor: "transparent"
                        textColor: Theme.txtPrimaryColor
                        bgHover: Qt.lighter(Theme.baseAlt1Color, 0.8)
                        bgDown: Qt.lighter(Theme.baseAlt1Color, 0.6)
                        height: Theme.smBtnHeight
                        text: qsTr("Cancel")

                        onClicked: timeselctorpopup.close()
                    }

                    // Update Time Button
                    DsButton {
                        bgColor: Theme.primaryColor
                        height: Theme.smBtnHeight
                        text: qsTr("Set")
                        textColor: Theme.baseColor

                        // When 'Set' button is clicked, get a copy of
                        // the current selected date, update its hour & minutes
                        // values and set it back to the 'selectedDate'
                        //
                        // NOTE setting the values directly withought the
                        // assignment operator '=' does not trigger the property change
                        onClicked: {
                            var sd = selectedDate
                            sd.setHours(hoursTumbler.currentIndex)
                            sd.setMinutes(minutesTumbler.currentIndex)
                            selectedDate = sd
                            timeselctorpopup.close()
                        }
                    }
                }
            }
        }
    }
}
