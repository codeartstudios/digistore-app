import QtQuick
import QtQuick.Controls
import app.digisto.modules

Label {
    color: Theme.txtPrimaryColor
    font.pixelSize: fontSize
    font.bold: isBold
    font.italic: isItalic
    font.weight: fontWeight
    font.underline: isUnderlined

    property int fontWeight: Font.Normal
    property real fontSize: Theme.h1
    property bool isBold: false
    property bool isItalic: false
    property bool isUnderlined: false
}
