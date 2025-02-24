pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Basic
import app.digisto.modules

import "../controls"

ComboBox {
    id: control

    property alias popupHeight: _p.height
    property alias radius: bg.radius
    property alias bgColor: bg.color
    property alias borderWidth: bg.border.width
    property alias borderColor: bg.border.color
    property bool alignLeft: true
    property var formattingFunc: null

    delegate: DsButton {
        id: btndlgt

        required property var model
        required property int index

        bgColor: control.highlightedIndex === index ?
                     Theme.baseAlt1Color : "transparent"
        bgHover: control.highlightedIndex === index ?
                     Qt.lighter(Theme.baseAlt1Color, 0.8) : "transparent"
        bgDown: control.highlightedIndex === index ?
                    Qt.lighter(Theme.baseAlt1Color, 0.6) : "transparent"
        textColor: Theme.txtPrimaryColor
        width: control.width
        fontSize: Theme.smFontSize
        text: control.formattingFunc ?
                  control.formattingFunc(model[textRole]) : model[textRole]

        contentItem: Item {
            DsLabel {
                fontSize: btndlgt.fontSize
                color: btndlgt.textColor
                text: btndlgt.text
                width: parent.width
                elide: DsLabel.ElideRight
                leftPadding: Theme.xsSpacing/2
                rightPadding: Theme.xsSpacing/2
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: control.alignLeft ?
                                         DsLabel.AlignLeft : DsLabel.AlignHCenter
            }
        }
    }

    indicator: Row {
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 12
        height: 8

        DsIcon {
            iconSize: Theme.smFontSize
            iconColor: Theme.txtPrimaryColor;
            iconType: IconType.caretUpDown
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    contentItem: DsLabel {
        leftPadding: Theme.xsSpacing
        rightPadding: control.indicator.width + control.spacing

        text: formattingFunc ? formattingFunc(model[control.currentIndex]) : control.displayText
        fontSize: Theme.smFontSize
        color: Theme.txtPrimaryColor
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        id: bg
        radius: Theme.xsSpacing
        implicitWidth: 120
        implicitHeight: Theme.btnHeight
        border.color: Theme.baseAlt1Color
        border.width: control.visualFocus ? 1 : 0
    }

    popup: Popup {
        id: _p
        y: control.height - 1
        width: control.width
        implicitHeight: contentItem.implicitHeight
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            radius: Theme.btnRadius
            color: Theme.bodyColor
            border.width: 1
            border.color: Theme.shadowColor
        }
    }
}
