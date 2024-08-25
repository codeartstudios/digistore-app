import QtQuick
import QtQuick.Layouts
import app.digisto.modules

Item {
    id: root
    implicitHeight: Theme.lgBtnHeight + Theme.smSpacing
    implicitWidth: 300

    property bool searchBarShown: true

    signal searchAccepted(var item)

    RowLayout {

        anchors.fill: parent
        anchors.leftMargin: Theme.xsSpacing
        anchors.rightMargin: Theme.xsSpacing

        Image {
            Layout.preferredWidth: Theme.btnHeight
            Layout.preferredHeight: Theme.btnHeight
            fillMode: Image.PreserveAspectFit
            source: "qrc:/assets/imgs/logo-nobg.png"
            verticalAlignment: Image.AlignVCenter
            Layout.alignment: Qt.AlignVCenter
        }

        Column {
            Layout.alignment: Qt.AlignVCenter

            DsLabel {
                isBold: true
                fontSize: Theme.xlFontSize
                text: qsTr("DigiStore")
            }

            DsLabel {
                fontSize: Theme.xsFontSize
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
            Layout.preferredHeight: Theme.lgBtnHeight
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        Item {
            Layout.fillWidth: true
            height: 1
        }

        DsIconButton {
            iconType: IconType.settings
        }

        DsIconButton {
            iconType: IconType.bell
        }

        Item {
            height: 1
            width: Theme.xsSpacing
        }

        Rectangle {
            color: Theme.baseAlt2Color
            width: 1; Layout.preferredHeight: Theme.btnHeight
            Layout.alignment: Qt.AlignVCenter
        }

        Item {
            height: 1
            width: Theme.xsSpacing
        }

        Column {
            Layout.alignment: Qt.AlignVCenter

            DsLabel {
                isBold: true
                fontSize: Theme.xlFontSize
                text: qsTr("John Doe")
                anchors.right: parent.right
            }

            DsLabel {
                fontSize: Theme.xsFontSize
                text: qsTr("Teller")
                anchors.right: parent.right
            }
        }

        Rectangle {
            height: Theme.btnHeight
            width: height
            radius: height/2
            color: Theme.baseAlt3Color
            Layout.alignment: Qt.AlignVCenter
        }
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.baseAlt1Color
        anchors.top: parent.bottom
    }
}
