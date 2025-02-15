import QtQuick

MouseArea {
    property bool hovered: false
    hoverEnabled: true
    onEntered: hovered=true
    onExited: hovered=false
}
