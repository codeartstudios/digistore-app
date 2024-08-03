import QtQuick

Item {
    property string title: qsTr("New Page")
    property bool awaitingRequest: false

    property var navigationStack
    property bool headerShown: true
    property var navigationHeader
    property bool headerTitleShown: true
}
