import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.platform
import app.digisto.modules
import QtQuick.Controls.Basic

import "../controls"

Popup {
    id: root
    width: 500
    height: 350
    modal: true
    x: (mainApp.width-width)/2
    y: (mainApp.height-height)/2
    closePolicy: Popup.NoAutoClose

    property var filterStartDate: new Date()
    property var filterEndDate: new Date()
    property string dateFormat: "ddd, MMMM dd, yyyy, hh:mm ap"

    signal rangeSelected()

    function compareStartEndDates(d1, d2) {
        if(d1.getFullYear() < d2.getFullYear()) return false;
        else if(d1.getFullYear() > d2.getFullYear()) return true;

        else {
            if(d1.getMonth() < d2.getMonth()) return false
            else if(d1.getMonth() > d2.getMonth()) return true
        }

        // If months are equal, check for the day
        if(d1.getDay() > d2.getDay()) return true;
        else if(d1.getDay() < d2.getDay()) return false;

        // Check for hours
        if(d1.getHours() > d2.getHours()) return true;
        else if(d1.getHours() < d2.getHours()) return false;

        // Check for minutes
        if(d1.getMinutes() > d2.getMinutes()) return true;
        else if(d1.getMinutes() < d2.getMinutes()) return false;

        return false;
    }

    background: Rectangle {
        color: Theme.bodyColor
        radius: Theme.btnRadius
    }

    contentItem: Item {
        anchors.fill: parent

        ColumnLayout {
            spacing: Theme.baseSpacing
            anchors.fill: parent

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.btnHeight
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.topMargin: Theme.xsSpacing

                Rectangle {
                    width: parent.width; height: 1
                    color: Theme.baseAlt1Color
                    anchors.bottom: parent.bottom
                }

                DsLabel {
                    fontSize: Theme.h1
                    color: Theme.txtHintColor
                    text: qsTr("Select Sales Date Range")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                }

                DsIconButton {
                    iconType: IconType.x
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                    radius: height/2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right

                    onClicked: root.close()
                }

            }

            Column {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.preferredHeight: Theme.xsBtnHeight + Theme.smBtnHeight

                DsLabel {
                    fontSize: Theme.baseFontSize
                    color: Theme.txtHintColor
                    text: qsTr("Start Date")
                    height: Theme.xsBtnHeight
                }

                RowLayout {
                    width: parent.width
                    spacing: Theme.xsSpacing
                    Layout.preferredHeight: Theme.smBtnHeight

                    DsLabel {
                        fontSize: Theme.baseFontSize
                        color: Theme.txtPrimaryColor
                        text: Qt.formatDateTime(filterStartDate, dateFormat)

                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignBottom
                    }

                    DsButton {
                        text: qsTr("Edit")

                        Layout.preferredHeight: Theme.smBtnHeight
                        Layout.alignment: Qt.AlignVCenter

                        onClicked: start_dtpicker.open()
                    }
                }
            }

            Column {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.preferredHeight: Theme.xsBtnHeight + Theme.smBtnHeight

                DsLabel {
                    fontSize: Theme.baseFontSize
                    color: Theme.txtHintColor
                    text: qsTr("End Date")
                    height: Theme.xsBtnHeight
                }

                RowLayout {
                    width: parent.width
                    spacing: Theme.xsSpacing
                    Layout.preferredHeight: Theme.smBtnHeight

                    DsLabel {
                        fontSize: Theme.baseFontSize
                        color: Theme.txtPrimaryColor
                        text: Qt.formatDateTime(filterEndDate, dateFormat)

                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignBottom
                    }

                    DsButton {
                        text: qsTr("Edit")

                        Layout.preferredHeight: Theme.smBtnHeight
                        Layout.alignment: Qt.AlignVCenter

                        onClicked: end_dtpicker.open()
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.btnHeight
                Layout.leftMargin: Theme.baseSpacing
                Layout.rightMargin: Theme.baseSpacing
                Layout.bottomMargin: Theme.baseSpacing

                RowLayout {
                    spacing: Theme.smSpacing
                    anchors.fill: parent

                    // Warning label to indicate end date be greater than start date
                    DsLabel {
                        fontSize: Theme.smFontSize
                        color: Theme.warningColor
                        text: filterEndDate < filterStartDate ? qsTr("Start date cann't be equal or greater than the end date") : ""
                        wrapMode: DsLabel.WordWrap

                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignBottom
                    }

                    DsButton {
                        text: qsTr("Submit")
                        endIcon: IconType.arrowRight
                        enabled: filterEndDate > filterStartDate

                        onClicked: rangeSelected()
                    }
                }
            }
        }
    }

    DsDateTimePicker {
        id: start_dtpicker
        x: (parent.width-width)/2
        y: (parent.height-height)/2

        onDateSelected: {
            filterStartDate = selectedDate
        }
    }

    DsDateTimePicker {
        id: end_dtpicker
        x: (parent.width-width)/2
        y: (parent.height-height)/2

        onDateSelected: {
            filterEndDate = selectedDate
        }
    }
}
