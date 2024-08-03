import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    // StackView properties
    required default property var initialItem
    property alias navigationStack: stack

    // Navigation header propertues
    property bool headerShown: true
    property alias navigationHeader: header
    property bool headerTitleShown: true

    ColumnLayout {
        anchors.fill: parent
        spacing: 1

        Rectangle {
            id: header
            color: "transparent"
            implicitHeight: 48
            Layout.fillWidth: true
            Layout.preferredHeight: headerShown ? implicitHeight : 0

            // Back Button, shown when the stack view has more than 1 page added
            DsIconButton {
                id: backButton
                bgColor: "transparent"
                radius: height/2
                bgHover: theme.baseAlt3Color
                textColor: theme.txtPrimaryColor
                anchors.left: parent.left
                anchors.leftMargin: theme.xsSpacing
                iconType: dsIconType.arrowNarrowLeft
                anchors.verticalCenter: parent.verticalCenter
            }

            Item {
                id: headerContentItem
                height: parent.height
                anchors.left: backButton.right
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                DsLabel {
                    visible: headerTitleShown
                    anchors.centerIn: parent
                    text: stack.currentItem.title ? stack.currentItem.title : qsTr("New Page")
                }
            }

            /// TODO add drop shadow to the header

            Rectangle {
                height: 1
                width: parent.width
                color: "silver"
                opacity: 0.8
                anchors.top: parent.bottom
            }
        }

        StackView {
            id: stack
            initialItem: root.initialItem
            Layout.fillWidth: true
            Layout.fillHeight: true

            Component.onCompleted: console.log(depth, currentItem)
        }
    }
}
