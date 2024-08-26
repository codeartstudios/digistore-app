import QtQuick
import QtQuick.Controls
import app.digisto.modules

Label {
    color: Theme.txtPrimaryColor
    font.pixelSize: fontSize
    font.bold: isBold
    font.italic: isItalic
    font.weight: fontWeight

    property int fontWeight: Font.Normal
    property real fontSize: Theme.h1
    property bool isBold: false
    property bool isItalic: false
}
