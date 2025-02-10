import QtQuick
import QtQuick.Controls
import app.digisto.modules

// TODO add notification dots

Item {
    id: sidebar
    width: Theme.appSidebarWidth

    signal menuSelected(var label)

    Item {
        anchors.fill: parent
        anchors.margins: Theme.smSpacing

        Item {
            id: logoitem
            width: parent.width
            height: Theme.lgBtnHeight + Theme.smSpacing
            anchors.top: parent.top

            Item {
                width: parent.width
                height: Theme.lgBtnHeight

                Image {
                    width: Theme.btnHeight
                    height: Theme.btnHeight
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/assets/imgs/logo-nobg.png"
                    verticalAlignment: Image.AlignVCenter
                    anchors.centerIn: parent
                }
            }
        }

        DsSideBarListView {
            width: parent.width
            model: globalModels.sideMenu
            anchors.bottom: extraslv.top
            anchors.top: logoitem.bottom
            anchors.bottomMargin: Theme.smSpacing
        }

        DsSideBarListView {
            id: extraslv
            width: parent.width
            height: (globalModels.sideMenuExtras.count * Theme.lgBtnHeight) + ((globalModels.sideMenuExtras.count-1) * spacing)
            anchors.bottom: parent.bottom
            model: globalModels.sideMenuExtras
        }

    }

    // Right Border line for the sidebar
    Rectangle {
        width: 1
        height: parent.height
        color: Theme.baseAlt1Color
        anchors.right: parent.right
    } // Rectangle: Right border line
}
