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
    property Requests requests: Requests{}
    property bool isRequestRunning: requests.running

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

                    DsImage {
                        source: orgBanner==="" ? "qrc:/assets/imgs/org-banner-default.jpg" : `https://pb.digisto.app/api/files/organization/${orgId}/${orgBanner}`
                        radius: Theme.btnRadius
                        anchors.fill: parent

                        DsButton {
                            iconType: IconType.edit
                            text: qsTr("Edit Details")
                            anchors.right: parent.right
                            anchors.top: parent.bottom
                            anchors.topMargin: Theme.baseSpacing
                        }
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

                        DsImage {
                            source: orgLogo==="" ? "qrc:/assets/imgs/org-logo-default.jpg" : `https://pb.digisto.app/api/files/organization/${orgId}/${orgLogo}`
                            radius: parent.height/2
                            anchors.fill: parent
                            anchors.margins: 2
                        }
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

    function fetchOrganizationDetails() {
        var orgid = dsController.organizationID
        requests.clear()
        requests.path = `/api/collections/organization/records/${orgid}`
        var res = requests.send();

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

        else if(res.status === 403) {
            showMessage("Access Error", "Only admins can access this action.")
        }

        else {
            showMessage("Organization Error", "The requested resource wasn't found.")
        }
    }

    Component.onCompleted: fetchOrganizationDetails()
}
