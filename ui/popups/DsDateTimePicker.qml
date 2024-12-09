import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.platform
import app.digisto.modules

import "../controls"

Popup {
    id: root
    width: 400
    height: 300
    modal: true
    x: (mainApp.width-width)/2
    y: (mainApp.height-height)/2
    closePolicy: Popup.NoAutoClose

    // onClosed: clearInputs()

    background: Rectangle {
        color: Theme.bodyColor
        radius: Theme.btnRadius
    }

    contentItem: Item {
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent

            DayOfWeekRow {
                Layout.column: 1
                Layout.fillWidth: true

                delegate: DsButton {
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

                delegate: DsButton {
                    //horizontalAlignment: DsLabel.AlignHCenter
                    //verticalAlignment: DsLabel.AlignVCenter
                    opacity: model.month === monthgrid.month ? 1 : 0
                    text: model.day
                    fontSize: Theme.smFontSize

                    required property var model
                }
            }
        }
    }

    onOpened: {
    }
}
