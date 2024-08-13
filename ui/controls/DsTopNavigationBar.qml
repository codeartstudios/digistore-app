import QtQuick
import QtQuick.Layouts

Item {
    id: root
    implicitHeight: theme.lgBtnHeight + theme.smSpacing
    implicitWidth: 300

    RowLayout {

        anchors.fill: parent
        anchors.leftMargin: theme.xsSpacing
        anchors.rightMargin: theme.xsSpacing

        Image {
            Layout.preferredWidth: theme.btnHeight
            Layout.preferredHeight: theme.btnHeight
            fillMode: Image.PreserveAspectFit
            source: "qrc:/assets/imgs/logo-nobg.png"
            verticalAlignment: Image.AlignVCenter
            Layout.alignment: Qt.AlignVCenter
        }

        Column {
            Layout.alignment: Qt.AlignVCenter

            DsLabel {
                isBold: true
                fontSize: theme.xlFontSize
                text: qsTr("DigiStore")
            }

            DsLabel {
                fontSize: theme.xsFontSize
                text: qsTr("Manage with ease")
            }
        }

        Item {
            Layout.fillWidth: true
            height: 1
        }

        DsSearchInput {
            id: dsSearchInput
            placeHolderText: qsTr("What are you looking for?")
            Layout.maximumWidth: 700
            Layout.preferredHeight: theme.lgBtnHeight
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        Item {
            Layout.fillWidth: true
            height: 1
        }

        DsIconButton {
            iconType: dsIconType.settings
        }

        DsIconButton {
            iconType: dsIconType.bell
        }

        Item {
            height: 1
            width: theme.xsSpacing
        }

        Rectangle {
            color: theme.baseAlt2Color
            width: 1; Layout.preferredHeight: theme.btnHeight
            Layout.alignment: Qt.AlignVCenter
        }

        Item {
            height: 1
            width: theme.xsSpacing
        }

        Column {
            Layout.alignment: Qt.AlignVCenter

            DsLabel {
                isBold: true
                fontSize: theme.xlFontSize
                text: qsTr("John Doe")
                anchors.right: parent.right
            }

            DsLabel {
                fontSize: theme.xsFontSize
                text: qsTr("Teller")
                anchors.right: parent.right
            }
        }

        Rectangle {
            height: theme.btnHeight
            width: height
            radius: height/2
            color: theme.baseAlt3Color
            Layout.alignment: Qt.AlignVCenter
        }
    }

    Rectangle {
        width: parent.width
        height: 1
        color: theme.baseAlt1Color
        anchors.top: parent.bottom
    }
}
