import QtQuick
import QtQuick.Layouts

import "../controls"

DsPage {
    id: root
    title: qsTr("Organization Page")
    headerShown: true

    Item {
        anchors.fill: parent
        anchors.margins: theme.lgSpacing

        RowLayout {
            spacing: theme.baseSpacing
            anchors.fill: parent

            Rectangle {
                color: theme.baseAlt1Color
                Layout.preferredWidth: theme.pageSidebarWidth
                Layout.fillHeight: true

                Column {
                    spacing: theme.xsSpacing
                    anchors.fill: parent
                    anchors.margins: theme.xsSpacing

                    Rectangle {
                        width: parent.width
                        height: width
                        radius: width/2
                        color: ma.hovered ? withOpacity(theme.baseColor, 0.8) : theme.baseColor

                        DsIconButton {
                            iconType: dsIconType.camera
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
                        iconType: dsIconType.edit
                        width: parent.width
                        text: qsTr("Edit Information")
                    }
                }
            }

            Rectangle {
                color: theme.baseAlt1Color
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
