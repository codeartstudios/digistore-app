import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

import "../controls"
import "../flow"

DsPage {
    id: root
    title: qsTr("Organization Page")
    headerShown: true

    property ListModel orgTabModel: ListModel{}
    property alias refreshEnabled: refreshBtn.enabled

    signal refreshPage()

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
                text: qsTr("Organization")
                Layout.alignment: Qt.AlignVCenter
            }

            DsLabel {
                fontSize: Theme.h1
                color: Theme.txtHintColor
                text: qsTr("/")
                Layout.alignment: Qt.AlignVCenter
            }

            DsLabel {
                fontSize: Theme.h2
                color: Theme.txtPrimaryColor
                text: tabslv.currentItem.text ? tabslv.currentItem.text : ""
                Layout.alignment: Qt.AlignVCenter
            }

            DsIconButton {
                id: refreshBtn
                iconType: IconType.reload
                textColor: Theme.txtPrimaryColor
                bgColor: "transparent"
                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                radius: height/2
                Layout.alignment: Qt.AlignVCenter

                onClicked: root.refreshPage()
            }

            Item {
                Layout.fillWidth: true
                height: 1
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: Theme.baseSpacing
            Layout.rightMargin: Theme.baseSpacing
            Layout.bottomMargin: Theme.baseSpacing

            ColumnLayout {
                id: orgStack
                anchors.fill: parent
                spacing: 0

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.btnHeight

                    ListView {
                        id: tabslv
                        model: orgTabModel
                        orientation: ListView.Horizontal
                        anchors.fill: parent
                        currentIndex: 0
                        delegate: DsTabButton {
                            active: index===tabslv.currentIndex
                            text: model.label
                            iconType: model.iconType

                            onClicked: {
                                tabslv.currentIndex=index
                                model.componentId.active=true
                            }
                        }
                    }
                }

                Rectangle {
                    color: Theme.baseAlt1Color
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        height: 1
                        color: Theme.bodyColor
                        width: parent.width
                        anchors.top: parent.top
                    }

                    StackLayout {
                        anchors.fill: parent
                        currentIndex: tabslv.currentIndex

                        Component.onCompleted: orginfoloader.active=true

                        // OrganizationInfoPage
                        DsFlowLoader {
                            id: orginfoloader
                            active: false
                            asynchronous: true
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            sourceComponent: Component {
                                id: orginfocomponent

                                OrganizationInfo {
                                    id: orginfopage

                                    // Binding {
                                    //     refreshBtn.enabled: orginfopage.isRequestRunning
                                    //     when: orgStack.currentIndex===0
                                    // }

                                    Connections {
                                        target: root

                                        function onRefreshPage() {
                                            if(orgStack.currentIndex===0)
                                                orginfopage.fetchOrganizationDetails();
                                        }
                                    }
                                }
                            }
                        } // OrganizationInfoPage Loader

                        // OrganizationBranchesPage
                        DsFlowLoader {
                            id: orgbranchesloader
                            active: false
                            asynchronous: true
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            sourceComponent: Component {
                                id: orgbranchescomponent

                                OrganizationBranches {
                                    id: orgbranchespage
                                }
                            }
                        } // OrganizationBranchesPage Loader

                        // OrganizationSettingsPage
                        DsFlowLoader {
                            id: orgsettingsloader
                            active: false
                            asynchronous: true
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            sourceComponent: Component {
                                id: orgsettingscomponent

                                OrganizationSettings {
                                    id: orgsettingspage
                                }
                            }
                        } // OrganizationSettingsPage Loader
                    }
                }
            }
        }
    }

    Component.onCompleted: orgTabModel.append([
                                                  {
                                                      label: "Info",
                                                      iconType: IconType.infoCircle,
                                                      componentId: orginfoloader
                                                  },
                                                  {
                                                      label: "Branches",
                                                      iconType: IconType.gitMerge,
                                                      componentId: orgbranchesloader
                                                  },
                                                  {
                                                      label: "Settings",
                                                      iconType: IconType.settings,
                                                      componentId: orgsettingsloader
                                                  }
                                              ])
}
