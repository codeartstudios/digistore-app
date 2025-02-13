import QtQuick
import app.digisto.modules

ListView {
    id: root
    spacing: Theme.btnRadius
    delegate: DsSidebarMenuItem {
        isActive: globalModels.currentSideBarMenu===model.label
        iconType: model.iconType
        toolTip: model.tooltip
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
