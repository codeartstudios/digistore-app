import QtQuick
import QtQuick.Layouts
import app.digisto.modules

Rectangle {
    id: root
    radius: Theme.btnRadius
    color: Theme.baseColor
    border.width: 1
    border.color: Theme.shadowColor

    property string label: qsTr("Sales summary")

    ColumnLayout {
        id: col
        spacing: Theme.xsSpacing
        anchors.fill: parent
        anchors.margins: Theme.xsSpacing

        // Label and period dropdown selection
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.xsSpacing

            DsLabel {
                text: root.label
                fontSize: Theme.xlFontSize
                height: Theme.btnHeight
                color: Theme.txtHintColor
                isBold: true
                elide: DsLabel.ElideRight
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }

            DsDashboardPillSelector {
                model: [qsTr("Last 7 Days"), qsTr("Last 30 Days"), qsTr("Last 3 Months")]
                onCurrentIndexChanged: {}
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

        }
    }
}
