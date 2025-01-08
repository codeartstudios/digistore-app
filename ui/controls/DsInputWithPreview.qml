import QtQuick.Controls.Basic
import QtQuick
import QtQuick.Layouts
import app.digisto.modules

Rectangle {
    id: control
    radius: Theme.btnRadius
    implicitWidth: 200
    height: col.height + Theme.xsSpacing
    color: Theme.baseAlt1Color

    property string label: qsTr("Input")
    property bool mandatory: false
    property alias secondaryActionLabel: secondaryActionLabel

    // Value label
    property string value: ""
    property alias placeHolderText: valuelabel.placeHolderText

    // Container properties
    property alias preview: container
    property alias previewHeight: container.height
    default property alias previewContent: container.children

    signal clicked()
    signal textAccepted()
    signal secondaryAction()

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if(control.enabled) {
                control.clicked()
            }
        }
    }

    Column {
        id: col
        spacing: 0
        width: parent.width - 2*Theme.xsSpacing
        anchors.centerIn: parent

        RowLayout {
            width: parent.width
            spacing: Theme.xsSpacing

            DsLabel {
                text: label
                color: Theme.txtPrimaryColor
                fontSize: Theme.xsFontSize

                DsLabel {
                    text: "*"
                    isBold: true
                    visible: mandatory
                    color: Theme.dangerColor
                    fontSize: Theme.lgFontSize
                    baselineOffset: parent.height
                    anchors.baseline: parent.baseline
                    anchors.left: parent.right
                    anchors.leftMargin: 1
                }
            }

            Item {
                Layout.fillWidth: true
                height: 1
            }

            DsLabel {
                id: secondaryActionLabel
                visible: text !== ""
                color: Theme.txtPrimaryColor
                fontSize: Theme.xsFontSize

                MouseArea {
                    anchors.fill: parent
                    onClicked: if(control.enabled) control.secondaryAction()
                }
            }
        }

        DsLabel {
            id: valuelabel
            property string placeHolderText: ""

            topPadding: Theme.xsSpacing/3
            bottomPadding: Theme.xsSpacing/2
            text: control.value==="" ? placeHolderText : control.value
            font.pixelSize: Theme.lgFontSize
            fontSize: Theme.xsFontSize
            width: parent.width
            color: control.value==="" ? Theme.txtDisabledColor : Theme.txtPrimaryColor
        }

        Item {
            id: container
            width: parent.width
            implicitHeight: 0
        }
    }
}
