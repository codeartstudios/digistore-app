import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import app.digisto.modules

import "../controls"
import "settings"

DsPage {
    id: root
    title: qsTr("Notifications")
    headerShown: false

    property ListModel notifications: ListModel{}

    ColumnLayout {
        anchors.fill: parent
        spacing: Theme.smSpacing

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.lgBtnHeight
            Layout.leftMargin: Theme.baseSpacing
            Layout.rightMargin: Theme.baseSpacing
            Layout.topMargin: Theme.smSpacing
            spacing: Theme.smSpacing

            DsLabel {
                fontSize: Theme.h1
                color: Theme.txtHintColor
                text: root.title
                Layout.alignment: Qt.AlignVCenter
            }

            DsIconButton {
                // enabled: !getproductrequest.running
                iconType: IconType.reload
                textColor: Theme.txtPrimaryColor
                bgColor: "transparent"
                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                radius: height/2
                Layout.alignment: Qt.AlignVCenter

                // onClicked: getProducts()
            }

            Item {
                Layout.fillWidth: true
                height: 1
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: notifications.count === 0

            Column {
                spacing: Theme.xsSpacing
                anchors.centerIn: parent

                DsIcon {
                    iconType: IconType.clearAll
                    iconSize: 100
                    color: Theme.txtHintColor
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                DsLabel {
                    color: Theme.txtHintColor
                    text: qsTr("Seems all clear for today!")
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: notifications.count > 0
        }
    }
}
