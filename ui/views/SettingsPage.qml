import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import app.digisto.modules

import "../controls"
import "settings"

DsPage {
    id: root
    title: qsTr("Settings Page")
    headerShown: false

    property string currentSettingsLabel: qsTr("General")
    property var settingsModel: [
        { label: qsTr("General"), icon: IconType.alignCenter },
        { label: qsTr("Account"), icon: IconType.userCircle }
    ]

    onCurrentSettingsLabelChanged: switchTo(currentSettingsLabel)

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

            DsLabel {
                fontSize: Theme.h1
                color: Theme.txtHintColor
                text: qsTr("/")
                Layout.alignment: Qt.AlignVCenter
            }

            DsLabel {
                fontSize: Theme.h2
                color: Theme.txtPrimaryColor
                text: root.currentSettingsLabel
                Layout.alignment: Qt.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
                height: 1
            }
        }

        RowLayout {
            spacing: Theme.baseSpacing
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: Theme.baseSpacing
            Layout.rightMargin: Theme.baseSpacing
            Layout.bottomMargin: Theme.baseSpacing

            ListView {
                id: categorylv
                model: root.settingsModel
                spacing: Theme.btnRadius
                Layout.preferredWidth: 300
                Layout.fillHeight: true

                delegate: DsButton {
                    id: settingslvdelegate
                    text: modelData.label
                    width: categorylv.width
                    textColor: Theme.txtPrimaryColor
                    bgColor: selected ? Theme.baseAlt1Color : "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                    onClicked: currentSettingsLabel = settingslvdelegate.text

                    property bool selected: root.currentSettingsLabel===settingslvdelegate.text

                    contentItem: Row {
                        spacing: Theme.xsSpacing/2
                        leftPadding: Theme.xsSpacing/2
                        rightPadding: Theme.xsSpacing/2
                        clip: true

                        DsIcon {
                            id: ico
                            width: parent.height
                            iconType: modelData.icon
                            iconSize: settingslvdelegate.fontSize * 1.2
                            color: settingslvdelegate.textColor
                            //label.verticalAlignment: DsLabel.alignVCenter
                            label.horizontalAlignment: DsLabel.alignHCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        DsLabel {
                            fontSize: settingslvdelegate.fontSize
                            color: settingslvdelegate.textColor
                            text: settingslvdelegate.text
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }

            StackView {
                id: settingsv
                Layout.fillWidth: true
                Layout.fillHeight: true
                initialItem: DsGeneralSettings {}
            }
        }
    }

    function switchTo(title) {
        if(settingsv.depth===0) return

        // Clear all stack items
        settingsv.pop(null, StackView.Immediate)

        // Push new stack item
        switch(title) {
        case qsTr("Account"): {
            settingsv.push("qrc:/ui/views/settings/DsAccountSettings.qml", StackView.Immediate)
            return
        }

        // default: settingsv.index = 0;
        }
    }
}
