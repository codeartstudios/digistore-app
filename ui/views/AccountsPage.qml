import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

import "../controls"
import "../popups"

DsPage {
    id: root
    title: "Accounts Page"
    headerShown: false

    property real pageNo: 1
    property real totalPages: 0
    property real totalItems: 0
    property real itemsPerPage: 200

    property string sortByKey: "name"
    property bool sortAsc: false

    // Page properties
    property string salesDateRange: qsTr("Today")
    property ListModel datamodel: ListModel{}

    ColumnLayout {
        anchors.fill: parent
        spacing: Theme.smSpacing

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.lgBtnHeight
            Layout.leftMargin: Theme.baseSpacing
            Layout.rightMargin: Theme.baseSpacing
            Layout.topMargin: Theme.smSpacing
            spacing: Theme.smSpacing

            DsLabel {
                fontSize: Theme.h1
                color: Theme.txtHintColor
                text: qsTr("Organization")
                Layout.alignment: Qt.AlignVCenter
            }

            DsLabel {
                fontSize: Theme.h1
                color: Theme.txtHintColor
                text: qsTr("/")
                Layout.alignment: Qt.AlignVCenter
            }

            DsLabel {
                fontSize: Theme.h2
                color: Theme.txtPrimaryColor
                text: qsTr("Users")
                Layout.alignment: Qt.AlignVCenter
            }

            DsIconButton {
                enabled: !getaccountsrequest.running
                iconType: IconType.reload
                textColor: Theme.txtPrimaryColor
                bgColor: "transparent"
                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                radius: height/2
                Layout.alignment: Qt.AlignVCenter

                onClicked: getTellers()
            }

            Item {
                Layout.fillWidth: true
                height: 1
            }

            DsMenu {
                id: accountsMenu
                iconType: IconType.pencilCog
                text: qsTr("Account Options")

                Component.onCompleted: {
                    menuModel.append({type: "", icon: IconType.usersPlus, label: qsTr("New User")})
                    menuModel.append({type: "spacer" })
                    menuModel.append({type: "", icon: IconType.userCog, label: qsTr("Account Settings")})
                }
            }
        }

        DsSearchInputNoPopup {
            id: dsSearchInput
            busy: getaccountsrequest.running
            placeHolderText: qsTr("Who are you looking for?")
            Layout.preferredHeight: Theme.lgBtnHeight
            Layout.fillWidth: true
            Layout.leftMargin: Theme.baseSpacing
            Layout.rightMargin: Theme.baseSpacing

            onAccepted: (txt) => getTellers()
        }

        DsTable {
            id: accountstable
            Layout.fillWidth: true
            Layout.fillHeight: true
            headerModel: headermodel
            dataModel: datamodel
            busy: getaccountsrequest.running
            pageNo: root.pageNo - 1
            itemsPerPage: root.itemsPerPage

            onSortBy: function(key) {
                if(key===sortByKey) {
                    sortAsc = !sortAsc;
                } else {
                    sortAsc = true;
                }

                sortByKey = key;

                getTellers()
            }

            // When current selected index changes, get the sales data
            // at given index and pass it to the drawer
            onCurrentIndexChanged: {
                // Open drawer only if current index is valid
                if( currentIndex >= 0 ) {
                    accountDrawer.userData = dataModel.get(currentIndex);
                    accountDrawer.open();
                } else {
                    // Close Drawer if already opened
                    if( accountDrawer.opened ) accountDrawer.close()
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.btnHeight
            Layout.bottomMargin: Theme.baseSpacing

            DsBusyIndicator {
                width: Theme.btnHeight
                height: Theme.btnHeight
                running: getaccountsrequest.running
                visible: running
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
            }

            Row {
                spacing: Theme.btnRadius
                anchors.right: parent.right
                anchors.rightMargin: Theme.baseSpacing

                DsLabel {
                    text: qsTr("Total Items  ") + `${totalItems}  `
                    color: Theme.txtHintColor
                    fontSize: Theme.smFontSize
                    anchors.verticalCenter: parent.verticalCenter
                }

                DsIconButton {
                    enabled: pageNo>1 && !getaccountsrequest.running
                    iconType: IconType.arrowLeft
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                    onClicked: {
                        pageNo -= 1
                        getTellers()
                    }
                }

                DsLabel {
                    text: `${pageNo} / ${totalPages}`
                    color: Theme.txtHintColor
                    fontSize: Theme.smFontSize
                    anchors.verticalCenter: parent.verticalCenter
                }

                DsIconButton {
                    enabled: pageNo<totalPages && !getaccountsrequest.running
                    iconType: IconType.arrowRight
                    textColor: Theme.txtPrimaryColor
                    bgColor: "transparent"
                    bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                    bgDown: withOpacity(Theme.baseAlt1Color, 0.6)

                    onClicked: {
                        pageNo += 1
                        getTellers()
                    }
                }
            }
        }
    }

    ListModel {
        id: headermodel

        ListElement {
            title: qsTr("Name")
            sortable: true
            width: 200
            flex: 2
            value: "name"
        }

        ListElement {
            title: qsTr("Username")
            sortable: true
            width: 200
            flex: 1
            value: "username"
        }

        ListElement {
            title: qsTr("Email")
            sortable: true
            width: 200
            flex: 1
            value: "email"
            formatBy: (email) => email ? email : "<redacted>"
        }

        ListElement {
            title: qsTr("Mobile")
            sortable: true
            width: 200
            flex: 1
            value: "mobile"
            formatBy: (data) => data ?
                          `(${data.dial_code})${data.number}` : "N/A"
        }

        ListElement {
            title: qsTr("Approved")
            sortable: true
            width: 200
            flex: 1
            value: "mobile"
            formatBy: (isApproved) => isApproved ? "true" : "false"
        }
    }

    // Drawer to display selected user account details from the table
    DsUserAccountDetailsDrawer {
        id: accountDrawer

        // Reset table current index when the drawer closes
        onClosed: accountstable.currentIndex = -1

        // When Account is deleted or updated, reload the info ...
        onUserDeleted: getTellers()
        onUserUpdated: {
            accountstable.currentIndex = -1
            getTellers()
        }
    }

    Requests {
        id: getaccountsrequest
        token: dsController.token
        baseUrl: dsController.baseUrl
        path: "/api/collections/tellers/records"
    }

    function getTellers() {
        var txt = dsSearchInput.text.trim()

        var query = {
            page: pageNo,
            perPage: itemsPerPage,
            sort: `${ sortAsc ? '+' : '-' }${ sortByKey }`,
            filter: `organization='${dsController.organization.id}'`
                    + (txt==='' ? '' : ` && (name ~ '${txt}' || email ~ '${txt}'
                       || username ~ '${txt}' || mobile.dial_code ~ '${txt}'
                       || mobile.number ~ '${txt}')`)
        }

        getaccountsrequest.clear()
        getaccountsrequest.query = query;
        var res = getaccountsrequest.send();

        if(res.status===200) {
            var data = res.data;
            pageNo=data.page
            totalPages=data.totalPages
            totalItems=data.totalItems
            var items = data.items;

            datamodel.clear()

            for(var i=0; i<items.length; i++) {
                datamodel.append(items[i])
            }
        }

        else if(res.status === 0) {
            showMessage(
                        qsTr("Connection Refused"),
                        qsTr("Could not connect to the server, something is'nt right!")
                        )
        }

        else if(res.status === 403) {
            showMessage(
                        qsTr("Authentication Error"),
                        qsTr("You don't seem to have access rights to perform this action.")
                        )
        }

        else {
            showMessage(
                        qsTr("Error Occured"),
                        res.message ? res.message : qsTr("Yuck! Something not right here!")
                        )
        }
    }

    Component.onCompleted: getTellers()
}

