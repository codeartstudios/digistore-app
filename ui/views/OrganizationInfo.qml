import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

import "../controls"
import "../popups"

Item {
    id: root

    property string orgName: ""
    property string orgDescription: ""
    property string orgEmail: ""
    property string orgAddress: ""
    property string orgMobile: ""
    property string orgId: ""
    property string orgBanner: ""
    property string orgLogo: ""
    property string orgDomain: ""
    property string orgCreated: ""
    property bool orgActivated: false

    property DsMessageBox messageBox: DsMessageBox{}

    ScrollView {
        anchors.fill: parent
        anchors.margins: Theme.smSpacing

        ScrollBar.vertical: ScrollBar{ policy: ScrollBar.AsNeeded }

        Column {
            width: parent.width
            spacing: Theme.xsSpacing

            Item {
                width: parent.width
                height: 350

                Rectangle {
                    width: parent.width
                    height: 250
                    color: Theme.baseAlt2Color
                    radius: Theme.btnRadius

                    Image {
                        anchors.fill: parent
                    }

                    Rectangle {
                        height: 200
                        width: 200
                        radius: height/2
                        border.width: 2
                        border.color: Theme.baseColor
                        anchors.verticalCenter: parent.bottom
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.baseSpacing
                    }
                }
            }

            DsFormTextElement {
                width: parent.width
                label: qsTr("Org. Name")
                value: orgName
            }

            Row {
                width: parent.width
                spacing: Theme.baseSpacing

                DsFormTextElement {
                    width: (parent.width-Theme.baseSpacing)/2
                    label: qsTr("Org. Email")
                    value: orgEmail
                }

                DsFormTextElement {
                    width: (parent.width-Theme.baseSpacing)/2
                    label: qsTr("Org. Mobile")
                    value: orgMobile
                }
            }

            Row {
                width: parent.width
                spacing: Theme.baseSpacing

                DsFormTextElement {
                    width: (parent.width-Theme.baseSpacing)/2
                    label: qsTr("Org. Address")
                    value: orgAddress
                }

                DsFormTextElement {
                    width: (parent.width-Theme.baseSpacing)/2
                    label: qsTr("Org. Domain")
                    value: orgDomain
                }
            }

            DsFormTextElement {
                width: parent.width
                label: qsTr("Org. Description")
                value: orgDescription
            }
        }
    }

    Requests {
        id: getorgrequest
        baseUrl: "https://pb.digisto.app"
    }

    function fetchOrganizationDetails() {
        var orgid = 'clhyn7tolbhy98k'
        getorgrequest.clear()
        getorgrequest.path = `/api/collections/organization/records/${orgid}`
        var res = getorgrequest.send();

        if(res.status===200) {
            var data = res.data;
            orgName = data.name
            orgDescription = data.description
            orgEmail = data.email
            orgAddress = data.address
            orgMobile = data.mobile
            orgId = data.id;
            orgBanner = data.banner
            orgLogo = data.logo
            orgDomain = data.domain
            orgActivated = data.approved
            orgCreated = data.created
        }

        else {
            messageBox.title = `Failed to fetch organization, something went wrong!`
            messageBox.info = res.status===403 ?  "Only admins can access this action." : "The requested resource wasn't found."
            messageBox.open()
        }
    }

    Component.onCompleted: fetchOrganizationDetails()
}
