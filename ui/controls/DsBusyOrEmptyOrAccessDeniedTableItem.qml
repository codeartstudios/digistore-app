import QtQuick
import app.digisto.modules

Item {
    id: root
    implicitHeight: emptyCol.height + Theme.lgBtnHeight * 4
    implicitWidth: 300
    visible: itemShown

    property bool itemShown: false
    property bool busy: false
    property bool accessAllowed: false
    property string accessDeniedText: qsTr("You don't have access to this view, please contact the organization Admin for assistance.")
    property string blankDisplayText: qsTr("This view seems to be empty, please reload or try adding some new data!")
    property string busyDisplayText: qsTr("Hold on, we are feching this data for you.")

    Column {
        id: emptyCol
        spacing: Theme.smSpacing
        width: parent.width * 0.5
        anchors.centerIn: parent

        DsIcon {
            iconSize: Theme.lgBtnHeight
            iconColor: Theme.txtHintColor
            iconType: root.busy ? IconType.clock : !root.accessAllowed ?
                                 IconType.shieldExclamation :
                                 IconType.folderExclamation
            anchors.horizontalCenter: parent.horizontalCenter
        }

        DsLabel {
            width: parent.width
            wrapMode: DsLabel.WordWrap
            color: Theme.txtHintColor
            fontSize: Theme.baseFontSize
            horizontalAlignment: DsLabel.AlignHCenter
            text: root.busy ? root.busyDisplayText : !root.accessAllowed ?
                             root.accessDeniedText : root.blankDisplayText
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}

