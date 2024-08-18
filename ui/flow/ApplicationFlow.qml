import QtQuick
import QtQuick.Layouts

// User imports
import "../controls"
import "../views"
import "../views/auth"

Item {
    anchors.fill: parent

    property bool sidebarShown: true
    property alias topBar: topbar

    ColumnLayout {
        id: collayout
        spacing: 0
        anchors.fill: parent

        DsTopNavigationBar {
            id: topbar
            Layout.fillWidth: true
        }

        RowLayout {
            spacing: 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            DsSideBar {
                Layout.preferredWidth: sidebarShown ? theme.appSidebarWidth : 0
                Layout.fillHeight: true
            }

            Loader {
                id: applicationLoader
                active: true
                sourceComponent: store.userLoggedIn ? dashboardComponent : authComponent
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
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

            TellerPage {

            }
        }
    }

    function withOpacity(color, opacity) {
        var r, g, b;

        // Named color
        if (color.startsWith("#")) {
            if (color.length === 7) { // #RRGGBB
                r = parseInt(color.substr(1, 2), 16) / 255.0;
                g = parseInt(color.substr(3, 2), 16) / 255.0;
                b = parseInt(color.substr(5, 2), 16) / 255.0;
            } else if (color.length === 4) { // #RGB
                r = parseInt(color.substr(1, 1) + color.substr(1, 1), 16) / 255.0;
                g = parseInt(color.substr(2, 1) + color.substr(2, 1), 16) / 255.0;
                b = parseInt(color.substr(3, 1) + color.substr(3, 1), 16) / 255.0;
            }
        } else if (color.startsWith("rgb")) {
            var rgbValues = color.match(/\d+/g);
            r = rgbValues[0] / 255.0;
            g = rgbValues[1] / 255.0;
            b = rgbValues[2] / 255.0;
        } else {
            // If it's a named color
            var tmpColor = Qt.color(color);
            r = tmpColor.r;
            g = tmpColor.g;
            b = tmpColor.b;
        }

        return Qt.rgba(r, g, b, opacity);
    }
}
