import QtQuick
import app.digisto.modules

Rectangle {
    id: root
    radius: Theme.btnRadius
    color: Theme.baseColor
    border.width: 1
    border.color: Theme.shadowColor

    Column {
        anchors.fill: parent
        anchors.margins: Theme.xsSpacing
        spacing: Theme.btnRadius

        DsLabel {
            width: parent.width
            text: qsTr("Quick Links")
            fontSize: Theme.xlFontSize
            height: Theme.btnHeight
            color: Theme.txtHintColor
            isBold: true
            elide: DsLabel.ElideRight
            bottomPadding: Theme.xsSpacing
        }

        DsDashboardQuickLinksDelegate {
            text: qsTr('Quick Lookup Item')
        }

        DsDashboardQuickLinksDelegate {
            text: qsTr('Close Session Book')
        }

        DsDashboardQuickLinksDelegate {
            text: qsTr('Lock Session')
        }
    }
}

