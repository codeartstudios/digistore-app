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

    delegate: DsButton {
        id: delegate

        required property var model
        required property int index

        bgColor: control.highlightedIndex === index ? Theme.baseAlt1Color : "transparent"
        bgHover: control.highlightedIndex === index ? Qt.lighter(Theme.baseAlt1Color, 0.8) : "transparent"
        bgDown: control.highlightedIndex === index ? Qt.lighter(Theme.baseAlt1Color, 0.6) : "transparent"
        textColor: Theme.txtPrimaryColor
        width: control.width
        fontSize: Theme.smFontSize
        text: delegate.model[control.textRole]
    }

    indicator: Canvas {
        id: canvas
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
            target: control
            function onPressedChanged() { canvas.requestPaint(); }
        }

        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = Theme.txtPrimaryColor;
            context.fill();
        }
    }

    contentItem: DsLabel {
        leftPadding: Theme.xsSpacing
        rightPadding: control.indicator.width + control.spacing

        text: control.displayText
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
            border.color: Theme.baseAlt1Color
            radius: Theme.xsSpacing
            color: Theme.bodyColor
            border.width: 1
        }
    }
}
