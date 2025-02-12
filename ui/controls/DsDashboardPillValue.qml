import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import app.digisto.modules

Rectangle {
    id: root
    implicitWidth: 200
    implicitHeight: col.height + Theme.xsSpacing * 2
    color: Theme.baseColor
    radius: Theme.btnRadius
    height: col.height + Theme.xsSpacing * 2
    border.width: 1
    border.color: Theme.shadowColor

    // Flag modes, signifying if a value set
    // has incresed/decreased/stagnated from
    // previous set value
    enum Mode {
        NULL,   // Reset state
        UP,     // Increasing or Up or Positive
        DOWN,   // Decreasing or Down or Negative
        FLAT    // No change or Zero
    }

    property string label: ''
    property string value: ''
    property real deviation: 0
    property string description: ''
    property string period: '7days'
    property alias deviationShown: devtRow.visible
    property alias trendIconShown: trendico.visible
    property int mode: DsDashboardPillValue.Mode.NULL

    readonly property var pillSelectionModel: {
        '7days': 0,
        '30days': 1,
        '3months': 2
    }

    QtObject {
        id: internal

        property string deviationIcon: ''
        property string deviationColor: 'transparent'
        property bool deviationsShown: mode!==DsDashboardPillValue.Mode.NULL
    }

    signal clicked()
    signal currentIndexChanged(index: int, label: string)

    onModeChanged: checkMode()
    Component.onCompleted: checkMode()

    Column {
        id: col
        spacing: Theme.btnRadius
        width: parent.width - Theme.xsSpacing * 2
        anchors.centerIn: parent

        // Label and period dropdown selection
        RowLayout {
            width: parent.width
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
                currentIndex: pillSelectionModel[period]
                onCurrentIndexChanged: root.currentIndexChanged(currentIndex, labelFromIndex(currentIndex))

                function labelFromIndex(currentIndex) {
                    if(currentIndex === 2)
                        return '3months'

                    if(currentIndex === 1)
                        return '30days'

                    else // 7days
                        return '7days'
                }
            }
        }

        DsLabel {
            isBold: true
            text: root.value
            fontSize: Theme.btnHeight

            Row {
                id: devtRow
                spacing: Theme.btnRadius
                anchors.bottom: parent.baseline
                anchors.left: parent.right
                anchors.leftMargin: Theme.btnRadius

                DsLabel {
                    visible: internal.deviationsShown
                    text: root.deviation >= 1000 ? `999+%` : `${root.deviation}%`
                    fontSize: Theme.baseFontSize
                    color: internal.deviationColor
                    anchors.baseline: parent.bottom
                }

                DsIcon {
                    id: trendico
                    visible: internal.deviationsShown
                    iconColor: internal.deviationColor
                    iconType: internal.deviationIcon
                    iconSize: Theme.lgFontSize
                    anchors.bottom: parent.bottom
                }
            }
        }

        DsLabel {
            text: root.description
            fontSize: Theme.smFontSize
            color: Theme.txtHintColor
            width: parent.width
            elide: DsLabel.ElideRight
        }
    }

    // Convenience function to assign color and icon
    function checkMode() {
        if(mode===DsDashboardPillValue.Mode.NULL) {
            internal.deviationIcon = ''
            internal.deviationColor = 'transparent'
        }

        else if(mode===DsDashboardPillValue.Mode.UP) {
            internal.deviationIcon = IconType.trendingUp
            internal.deviationColor = Theme.successColor
        }

        else if(mode===DsDashboardPillValue.Mode.DOWN) {
            internal.deviationIcon = IconType.trendingDown
            internal.deviationColor = Theme.dangerColor
        }

        else if(mode===DsDashboardPillValue.Mode.FLAT) {
            internal.deviationIcon = IconType.lineDashed
            internal.deviationColor = Theme.warningColor
        }
    }
}
