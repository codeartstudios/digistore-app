import QtQuick 2.15

// User imports
import "../controls"
import "../views/auth"

Item {
    anchors.fill: parent

    Loader {
        id: applicationLoader
        active: true
        sourceComponent: store.userLoggedIn ? dashboardComponent : authComponent
        anchors.fill: parent
    }

    Component {
        id: authComponent

        DsNavigationStack {
            id: authStack

            Login {

            }
        }
    }

    Component {
        id: dashboardComponent

        DsNavigationStack {
            id: dashStack

            Login {

            }
        }
    }
}
