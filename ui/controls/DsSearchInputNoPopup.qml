import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Basic as QQCB
import app.digisto.modules

Item {
    id: root
    implicitHeight: 70
    implicitWidth: 500

    signal accepted(var object)

    // Delay between typing before we make a request
    property int delay: 500
    property alias placeHolderText: input.placeholderText
    property alias busy: searchbtn.busy

    MouseArea {
        anchors.fill: parent
        onClicked: input.forceActiveFocus()
    }

    Rectangle {
        id: rec
        color: Theme.baseAlt1Color
        radius: Theme.btnRadius
        anchors.fill: parent

        RowLayout {
            spacing: Theme.xsSpacing/2
            anchors.fill: parent

            DsIcon {
                iconSize: input.font.pixelSize
                iconType: IconType.search
                Layout.leftMargin: Theme.xsSpacing
                Layout.alignment: Qt.AlignVCenter
            }

            QQCB.TextField {
                id: input
                padding: 0
                width: parent.width - Theme.xsSpacing
                height: Theme.inputHeight
                color: Theme.txtPrimaryColor
                placeholderTextColor: Theme.txtDisabledColor
                font.pixelSize: Theme.xlFontSize
                echoMode: TextField.Normal
                background: Item {}
                onAccepted: root.accepted(input.text)

                Layout.fillWidth: true
                Layout.rightMargin: Theme.xsSpacing
            }

            DsIconButton {
                radius: height/2
                visible: input.text !== ""
                iconSize: input.font.pixelSize
                iconType: IconType.x
                textColor: Theme.txtPrimaryColor
                bgColor: "transparent"
                bgHover: Theme.dangerAltColor
                bgDown: withOpacity(Theme.dangerAltColor, 0.8)
                Layout.rightMargin: Theme.xsSpacing
                Layout.alignment: Qt.AlignVCenter

                onClicked: {
                    input.clear()
                    root.accepted("")
                }
            }

            DsIconButton {
                id: searchbtn
                radius: Theme.btnRadius
                enabled: input.text !== ""
                iconSize: input.font.pixelSize
                iconType: IconType.search
                textColor: Theme.txtPrimaryColor
                bgColor: Theme.baseColor
                bgHover: Theme.dangerAltColor
                bgDown: withOpacity(Theme.dangerAltColor, 0.8)
                Layout.fillHeight: true
                Layout.preferredWidth: 80
                Layout.rightMargin: Theme.btnRadius
                Layout.topMargin: Theme.btnRadius
                Layout.bottomMargin: Theme.btnRadius
                Layout.alignment: Qt.AlignVCenter

                onClicked: root.accepted(input.text)
            }
        }
    }
}
