import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

import "../controls"

DsPage {
    id: root
    title: qsTr("Organization Page")
    headerShown: true

    Item {
        anchors.fill: parent
        anchors.margins: Theme.lgSpacing

        RowLayout {
            spacing: Theme.baseSpacing
            anchors.fill: parent

            Rectangle {
                radius: Theme.btnRadius
                color: Theme.baseColor
                Layout.preferredWidth: Theme.pageSidebarWidth
                Layout.fillHeight: true

                Column {
                    spacing: Theme.xsSpacing
                    anchors.fill: parent
                    anchors.margins: Theme.xsSpacing

                    Rectangle {
                        width: parent.width
                        height: width
                        radius: width/2
                        color: ma.hovered ? withOpacity(Theme.baseColor, 0.8) : Theme.baseColor

                        DsIconButton {
                            iconType: IconType.camera
                            visible: ma.hovered
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            id: ma

                            property bool hovered: false

                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: hovered=true
                            onExited: hovered=false
                            onClicked: {}
                        }
                    }

                    DsFormTextElement {
                        label: qsTr("Name")
                        value: qsTr("Koaley Group Ltd.")
                    }

                    DsFormTextElement {
                        label: qsTr("Description")
                        value: qsTr("A short description of the organization and the location details.")
                    }

                    DsFormTextElement {
                        label: qsTr("Date Added")
                        value: "12th June 2023"
                    }

                    DsFormTextElement {
                        label: qsTr("Plan")
                        value: "Basic"
                    }

                    DsFormTextElement {
                        label: qsTr("Mobile")
                        value: "+254700986567"
                    }

                    DsFormTextElement {
                        label: qsTr("Email")
                        value: "admin@koaleygroup.com"
                    }

                    DsFormTextElement {
                        label: qsTr("Website")
                        value: "https://koaleygroup.com"
                    }

                    DsButton {
                        iconType: IconType.edit
                        width: parent.width
                        text: qsTr("Edit Information")
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Theme.btnHeight

                        ListView {
                            id: tabslv
                            model: ["Info", "Branches", "Details", "Settings"]
                            orientation: ListView.Horizontal
                            anchors.fill: parent
                            currentIndex: 0
                            delegate: DsTabButton {
                                active: index===tabslv.currentIndex
                                text: modelData
                                iconType: IconType.settings

                                onClicked: tabslv.currentIndex=index
                            }
                        }
                    }

                    Rectangle {
                        color: Theme.baseAlt1Color
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        // Tabbar for:  1. Sub Organizational Units
                        //              2. User Accounts in the organization
                        //              2. //
                    }
                }
            }
        }
    }
}
