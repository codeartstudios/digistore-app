import QtQuick
import QtQuick.Controls

Item {
    id: sidebar
    width: theme.appSidebarWidth

    property string currentSideBarMenu: "dashboard"
    property ListModel sideMenu: ListModel{}

    signal menuSelected(var label)

    Column {
        spacing: theme.btnRadius
        anchors.fill: parent
        anchors.margins: theme.smSpacing

        Repeater {
            model: sideMenu
            delegate: DsIconButton {
                property bool isActive: currentSideBarMenu===model.label

                iconType: model.iconType
                toolTip: model.tooltip
                width: theme.lgBtnHeight
                height: width
                iconSize: 28
                bgColor: isActive ? theme.baseAlt1Color : "transparent"
                bgHover: withOpacity(theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(theme.baseAlt1Color, 0.6)
                textColor: isActive ? theme.txtPrimaryColor : withOpacity(theme.txtPrimaryColor, 0.6)
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
                    color: theme.primaryColor
                    height: visible ? 0.5 * parent.height : 0
                    width: theme.btnRadius
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
        color: theme.baseAlt1Color
        anchors.right: parent.right
    } // Rectangle: Right border line

    Component.onCompleted: {
        sideMenu.append({
                            checkable: true,
                            label: "dashboard",
                            tooltip: "Org. Dashboard",
                            isBusy: false,
                            iconType: dsIconType.chalkboard
                        })

        sideMenu.append({
                            checkable: true,
                            label: "teller",
                            tooltip: "Cart Checkout",
                            isBusy: false,
                            iconType: dsIconType.shoppingCartCheck
                        })

        sideMenu.append({
                            checkable: true,
                            label: "inventory",
                            tooltip: "Org. Inventory",
                            isBusy: false,
                            iconType: dsIconType.buildingWarehouse
                        })

        sideMenu.append({
                            checkable: true,
                            label: "organization",
                            tooltip: "My Organization",
                            isBusy: false,
                            iconType: dsIconType.briefcase2
                        })

        sideMenu.append({
                            checkable: true,
                            label: "sales",
                            tooltip: "Org. Sales",
                            isBusy: false,
                            iconType: dsIconType.tableShare
                        })
    }
}
