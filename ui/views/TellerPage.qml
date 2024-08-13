import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.qmlmodels

import "../controls"

/*
  TellerPage
*/

DsPage {
    id: loginPage
    title: qsTr("Teller Page")

    headerShown: false

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        DsTopNavigationBar {
            Layout.fillWidth: true
        }

        Rectangle {
            border.color: theme.baseAlt1Color
            border.width: 1
            radius: theme.btnRadius
            color: "transparent"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: theme.xsSpacing

            ListView {
                id: listView
                spacing: 1
                model: 5
                anchors.fill: parent

                header: Rectangle {
                    color: theme.baseAlt1Color
                    height: theme.lgBtnHeight
                    width: listView.width
                }

                delegate: Item {
                    height: theme.lgBtnHeight
                    width: listView.width

                    Rectangle {
                        height: 1
                        color: theme.baseAlt1Color
                        width: parent.width
                        anchors.bottom: parent.bottom
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        mytablemodel.append({"title":1,"title1":2,"title2":3,"title3":4,"title4":5,"title5":6})
        mytablemodel.append({"title":1,"title1":2,"title2":3,"title3":4,"title4":5,"title5":6})
        mytablemodel.append({"title":1,"title1":2,"title2":3,"title3":4,"title4":5,"title5":6})
        mytablemodel.append({"title":1,"title1":2,"title2":3,"title3":4,"title4":5,"title5":6})
        mytablemodel.append({"title":1,"title1":2,"title2":3,"title3":4,"title4":5,"title5":6})
    }

    ListModel{
        id:mytablemodel
    }
}
