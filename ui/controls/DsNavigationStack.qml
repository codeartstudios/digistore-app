import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

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
            visible: headerShown
            Layout.fillWidth: true
            Layout.preferredHeight: headerShown ? implicitHeight : 0

            // Back Button, shown when the stack view has more than 1 page added
            DsIconButton {
                id: backButton
                radius: height/2
                visible: stack.depth > 1
                bgColor: "transparent"
                bgHover: Theme.baseAlt3Color
                bgDown: Theme.baseAlt3Color
                textColor: Theme.txtPrimaryColor
                iconType: IconType.arrowNarrowLeft

                anchors.left: parent.left
                anchors.leftMargin: Theme.xsSpacing
                anchors.verticalCenter: parent.verticalCenter

                onClicked: stack.pop()
            }

            Item {
                id: headerContentItem
                height: parent.height
                anchors.left: backButton.right
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                DsLabel {
                    id: headerTitle
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

            onCurrentItemChanged:  {
                currentItem.navigationStack = stack
                headerShown = currentItem.headerShown
                currentItem.navigationHeader = header
                headerTitleShown = currentItem.headerTitleShown
            }
        }
    }
}
