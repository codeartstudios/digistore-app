import QtQuick.Controls

Label {
    color: theme.txtPrimaryColor
    font.pixelSize: fontSize
    font.bold: isBold
    font.italic: isItalic

    property real fontSize: theme.h1
    property bool isBold: false
    property bool isItalic: false
}
