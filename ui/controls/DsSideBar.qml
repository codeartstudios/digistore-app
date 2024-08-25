import QtQuick
import QtQuick.Controls
import app.digisto.modules

Item {
    id: sidebar
    width: Theme.appSidebarWidth

    property string currentSideBarMenu: "dashboard"
    property ListModel sideMenu: ListModel{}

    signal menuSelected(var label)

    Column {
        spacing: Theme.btnRadius
        anchors.fill: parent
        anchors.margins: Theme.smSpacing

        Repeater {
            model: sideMenu
            delegate: DsIconButton {
                property bool isActive: currentSideBarMenu===model.label

                iconType: model.iconType
                toolTip: model.tooltip
                width: Theme.lgBtnHeight
                height: width
                iconSize: 28
                bgColor: isActive ? Theme.baseAlt1Color : "transparent"
                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                textColor: isActive ? Theme.txtPrimaryColor : withOpacity(Theme.txtPrimaryColor, 0.6)
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {
                    if(model.checkable) currentSideBarMenu = model.label
                    menuSelected(model.label)
                }

                onIsActiveChanged: isActive ? indicator.fadeIn() :
                                              indicator.fadeOut()

                Rectangle {
                    id: indicator
                    visible: parent.isActive
                    radius: width/2
                    color: Theme.primaryColor
                    height: visible ? 0.5 * parent.height : 0
                    width: Theme.btnRadius
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on height { NumberAnimation {} }

                    function fadeIn() { fadein.restart() }
                    function fadeOut() { fadeout.restart() }

                    OpacityAnimator {
                        id: fadein
                        target: indicator
                        from: 0; to: 1
                    }

                    OpacityAnimator {
                        id: fadeout
                        target: indicator
                        from: 1; to: 0
                    }
                }
            }
        }
    }

    // Right Border line for the sidebar
    Rectangle {
        width: 1
        height: parent.height
        color: Theme.baseAlt1Color
        anchors.right: parent.right
    } // Rectangle: Right border line

    Component.onCompleted: {
        sideMenu.append({
                            checkable: true,
                            label: "dashboard",
                            tooltip: "Org. Dashboard",
                            isBusy: false,
                            iconType: IconType.chalkboard
                        })

        sideMenu.append({
                            checkable: true,
                            label: "teller",
                            tooltip: "Cart Checkout",
                            isBusy: false,
                            iconType: IconType.shoppingCartCheck
                        })

        sideMenu.append({
                            checkable: true,
                            label: "inventory",
                            tooltip: "Org. Inventory",
                            isBusy: false,
                            iconType: IconType.buildingWarehouse
                        })

        sideMenu.append({
                            checkable: true,
                            label: "organization",
                            tooltip: "My Organization",
                            isBusy: false,
                            iconType: IconType.briefcase2
                        })

        sideMenu.append({
                            checkable: true,
                            label: "sales",
                            tooltip: "Org. Sales",
                            isBusy: false,
                            iconType: IconType.tableShare
                        })
    }
}
