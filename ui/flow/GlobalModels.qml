import QtQuick
import app.digisto.modules

Item {
    // Organization Page Tab Model
    // Holds the tab information for tab switching
    property ListModel orgTabModel: ListModel{}

    function populateOrgTabModel() {
        orgTabModel.clear()
        orgTabModel.append({
                               label: "Info",
                               iconType: IconType.infoCircle
                               // componentId: orginfoloader
                           })

        orgTabModel.append({
                               label: "Accounts & Permissions",
                               iconType: IconType.users
                               // componentId: orginfoloader
                           })

        orgTabModel.append({
                               label: "Branches",
                               iconType: IconType.gitMerge
                               // componentId: orgbranchesloader
                           })

        orgTabModel.append({
                               label: "Settings",
                               iconType: IconType.settings
                               // componentId: orgsettingsloader
                           })
    }

    Component.onCompleted: {
        populateOrgTabModel()
    }
}
