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
    height: 400
    modal: true
    x: (mainApp.width-width)/2
    y: (mainApp.height-height)/2
    // closePolicy: Popup.NoAutoClose

    property var selectedDate: new Date()
    property int minimumYear: 2000
    property int maximumYear: new Date().getFullYear()

    property var yearsModel: []

    onMinimumYearChanged: fillYearModel()
    onMaximumYearChanged: fillYearModel()

    function fillYearModel() {
        var years = []

        for(var y=minimumYear; y<=maximumYear; y++) {
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

            Column {
                spacing: Theme.xsSpacing
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.btnHeight + Theme.smBtnHeight + spacing

                RowLayout {
                    width: parent.width
                    height: Theme.btnHeight
                    spacing: Theme.xsSpacing

                    DsComboBox {
                        id: yearcb
                        model: yearsModel
                        popupHeight: monthgrid.height
                        onCurrentValueChanged: monthgrid.year = currentValue
                    }

                    DsComboBox {
                        id: monthcb
                        popupHeight: monthgrid.height
                        model: ["January", 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
                        onCurrentIndexChanged: monthgrid.month = currentIndex
                    }

                    DsButton {
                        bgColor: "transparent"
                        textColor: Theme.txtPrimaryColor
                        bgHover: Qt.lighter(Theme.baseAlt1Color, 0.8)
                        bgDown: Qt.lighter(Theme.baseAlt1Color, 0.6)
                        height: Theme.btnHeight
                        text: Qt.formatTime(selectedDate, "hh:mm")
                    }

                    DsButton {
                        height: Theme.btnHeight
                        text: qsTr("Set")
                    }
                }

                DsLabel {
                    text: Qt.formatDateTime(selectedDate, "ddd MMMM yyyy, hh:mm ap")
                    color: Theme.txtPrimaryColor
                    height: Theme.smBtnHeight
                    verticalAlignment: DsLabel.AlignVCenter
                    fontSize: Theme.baseFontSize
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

                Component.onCompleted: console.log(Calendar.December)

                onClicked: (dt) => dt.set

                delegate: DsButton {
                    width: Theme.smBtnHeight
                    height: Theme.btnHeight
                    opacity: model.month === monthgrid.month ? 1 : 0.4
                    text: model.day
                    fontSize: Theme.smFontSize
                    bgColor: isSelectedDate ? Theme.baseAlt4Color : Theme.baseAlt1Color
                    textColor: Theme.txtPrimaryColor

                    onClicked: monthgrid.clicked(new Date(model.year, model.month, model.day))

                    required property var model
                    property bool isSelectedDate: model.year===root.selectedDate.getFullYear() && model.month===root.selectedDate.getMonth() && model.day===root.selectedDate.getDay()
                }
            }
        }
    }

    onOpened: {
    }
}
