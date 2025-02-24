import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import app.digisto.modules

import "../controls"
import "../popups"

DsDrawer {
    id: root
    width: mainApp.width * 0.9
    modal: true

    signal reloadOrganization()
    property bool fetchOrganizationInProgess: false

    QtObject {
        id: internal

        property bool loaded: false         // Finished loading all controls
        property var orgSettingsObj: null   // Settings Object for the Org
        property var orgUpdatedObj: null    // Updated fields for the Org

        // Flag to be set when organization details are updated
        property bool orgDetailsEdited: false
    }

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
                text: qsTr("Settings")
                Layout.alignment: Qt.AlignVCenter
            }

            DsIconButton {
                enabled: !fetchOrganizationInProgess
                iconType: IconType.reload
                textColor: Theme.txtPrimaryColor
                bgColor: "transparent"
                bgHover: withOpacity(Theme.baseAlt1Color, 0.8)
                bgDown: withOpacity(Theme.baseAlt1Color, 0.6)
                radius: height/2
                Layout.alignment: Qt.AlignVCenter

                onClicked: reloadOrganization()
            }

            Item {
                Layout.fillWidth: true
                height: 1
            }

            DsButton {
                enabled: internal.orgDetailsEdited && !request.running
                visible: internal.orgDetailsEdited && loggedUserPermissions.canEditOrganization
                opacity: visible ? 1 : 0
                iconType: IconType.pencilCheck
                busy: request.running
                text: qsTr("Update Organization")
                bgColor: Theme.successColor
                textColor: Theme.baseColor
                Layout.alignment: Qt.AlignVCenter

                Behavior on opacity { OpacityAnimator { easing.type: Easing.InOutQuad }}

                onClicked: updateOrganization()
            }
        }

        DsSettingsStackPage {
            id: scrollview
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: Theme.baseSpacing
            Layout.rightMargin: Theme.baseSpacing

            // Organization Details
            DsSettingsCard {
                width: parent.width
                title: qsTr("Organization Info")
                desc: qsTr("Description of the organization details.")

                DsSettingsRowTextInput {
                    label: qsTr("Org. Name")
                    text: dsController.organization.name
                    placeholderText: qsTr("Some Org Inc.")
                    onTextChanged: setKey('name', text)
                }

                DsSettingsRowTextInput {
                    label: qsTr("Org. Description")
                    text: dsController.organization.description
                    placeholderText: qsTr("Our org description, slogan, etc.")
                    onTextChanged: setKey('description', text)
                }

                DsSettingsRowTextInput {
                    label: qsTr("Org. Email")
                    validator: globalModels.emailRegex
                    text: dsController.organization.email
                    placeholderText: qsTr("email@org.com")
                    onTextChanged: setKey('email', text)
                }

                DsSettingsRowTextInput {
                    label: qsTr("Org. Website")
                    text: dsController.organization.domain
                    placeholderText: qsTr("https://someorg.com")

                    onTextChanged: setKey('domain', text)
                }

                RowLayout {
                    width: parent.width
                    spacing: Theme.xsSpacing

                    DsLabel {
                        text: qsTr("Org. Mobile")
                        fontSize: Theme.baseFontSize
                        color: Theme.txtPrimaryColor
                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillWidth: true
                    }

                    DsInputMobileNumber {
                        id: orgmobileinput
                        text: getNumber(dsController.organization.mobile)
                        color: Theme.bodyColor
                        input.placeholderText: qsTr("7xx xxx xxx")
                        labelShown: false
                        Layout.minimumWidth: 300

                        onTextChanged: updateMobile()
                        onSelectedCountryChanged: updateMobile()

                        function getNumber(mobile) {
                            // Set mobile number
                            text = (mobile && mobile.number) ? mobile.number : ''

                            // Set Dial Code
                            if(mobile && mobile.dial_code)
                                orgmobileinput.findAndSetCountryByDialCode(mobile.dial_code)
                        }

                        function updateMobile() {
                            setKey('mobile', {
                                       dial_code: selectedCountry ? selectedCountry.dial_code : '',
                                       number: text
                                   })
                        }
                    }
                }
            }

            // Organization Settings
            DsSettingsCard {
                width: parent.width
                title: qsTr("Organization Settings")
                desc: qsTr("Configure organization settings")

                RowLayout {
                    width: parent.width
                    spacing: Theme.xsSpacing

                    DsLabel {
                        text: qsTr("Organization Workspace")
                        fontSize: Theme.baseFontSize
                        color: Theme.txtPrimaryColor
                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillWidth: true
                    }

                    DsInputWithLabel {
                        id: orgworkspaceinput
                        labelShown: false
                        text: dsController.organization.workspace
                        color: Theme.bodyColor
                        input.placeholderText: qsTr("https://digisto.app/co/__")
                        Layout.minimumWidth: 300

                        onTextChanged: setKey('workspace', text)
                    }
                }

                // Domain
                RowLayout {
                    width: parent.width
                    spacing: Theme.xsSpacing

                    DsLabel {
                        text: qsTr("Server Root Domain")
                        fontSize: Theme.baseFontSize
                        color: Theme.txtPrimaryColor
                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillWidth: true
                    }

                    DsInputWithLabel {
                        readOnly: true
                        labelShown: false
                        color: Theme.bodyColor
                        text: dsController.baseUrl
                        input.placeholderText: qsTr("https://digisto.app")
                        Layout.minimumWidth: 300
                    }
                }

                // Currency
                RowLayout {
                    width: parent.width
                    spacing: Theme.xsSpacing

                    DsLabel {
                        text: qsTr("Workspace default currency")
                        fontSize: Theme.baseFontSize
                        color: Theme.txtPrimaryColor
                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillWidth: true
                    }

                    DsComboBox {
                        id: currecycb
                        height: Theme.inputHeight + Theme.xsSpacing
                        radius: Theme.btnRadius
                        bgColor: Theme.bodyColor
                        currentIndex: getCurrentIndex(orgCurrency)
                        model: StaticModels.worldCurrencyModel
                        popupHeight: root.height * 0.6
                        Layout.minimumWidth: 300

                        formattingFunc: (obj) => obj ? `${obj.name} (${obj.symbol})` : '--'

                        function getCurrentIndex(obj) {
                            try {
                                const key = 'cc'
                                for(var i=0; i<StaticModels.worldCurrencyModel.length; i++) {
                                    var model_i = StaticModels.worldCurrencyModel[i]
                                    if(model_i[key].toLowerCase() === obj.cc.toLowerCase()) {

                                        currentIndex = i
                                        return
                                    }
                                }

                                currentIndex = 0
                            } catch(err) {
                                currentIndex = 0
                            }
                        }

                        onCurrentIndexChanged: {
                            if(internal.loaded) {
                                const cc = currentIndex >= 0 ? currecycb.model[currentIndex].cc : 'usd'
                                internal.orgSettingsObj['currency'] = cc

                                // Update edited flag
                                internal.orgDetailsEdited = true
                            }
                        }
                    }
                }

                // Lock timeout
                RowLayout {
                    width: parent.width
                    spacing: Theme.xsSpacing

                    DsLabel {
                        text: qsTr("App lock timeout")
                        fontSize: Theme.baseFontSize
                        color: Theme.txtPrimaryColor
                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillWidth: true
                    }

                    DsComboBox {
                        height: Theme.inputHeight + Theme.xsSpacing
                        radius: Theme.btnRadius
                        bgColor: Theme.bodyColor
                        model: [qsTr("True"), qsTr("False")]
                        currentIndex: dsController.organization.settings.screen_timeout_enabled ? 0 : 1
                        Layout.minimumWidth: 300

                        onCurrentIndexChanged: {
                            if(internal.loaded) {
                                internal.orgSettingsObj['screen_timeout_enabled'] = currentIndex===0 ?
                                            true : false

                                // Update edited flag
                                internal.orgDetailsEdited = true
                            }
                        }
                    }
                }
            }

            // Bottom spacer ...
            Item {
                height: 20
                width: 1
            }
        }
    }

    onOpened: {
        // Reset loaded flag
        internal.loaded = false

        var _settings = dsController.organization.settings
        var _org = {
            name:         dsController.organization.name,
            description:  dsController.organization.description,
            address:      dsController.organization.address,
            email:        dsController.organization.email,
            mobile:       dsController.organization.mobile,
            workspace:    dsController.organization.workspace,
            workspace_url: dsController.organization.workspace_url,
            domain:       dsController.organization.domain,
            approved:     dsController.organization.approved,
            logo:         dsController.organization.logo,
            banner:       dsController.organization.banner
        }

        internal.orgSettingsObj = _settings     // Settings Object from the Org
        internal.orgUpdatedObj = _org           // Copy of the Org Details [redacted version]
        internal.orgUpdatedObj = internal.orgUpdatedObj // Set to itself, triggers changed signal
        internal.orgDetailsEdited = false       // Reset Flag

        // Set loaded flag as true
        internal.loaded = true
    }

    onClosed: {
        // Reset loaded flag
        internal.loaded = false

        if(internal.orgDetailsEdited)
            toast.warning("All pending changes were discarded!")

        // Reset orgDetailsEdited Flag
        internal.orgDetailsEdited = false
    }

    // Given the JSON key & value, update the org Obj
    function setKey(key, value) {
        if(!internal.loaded) return // Update only when loaded is set

        internal.orgDetailsEdited = true
        internal.orgUpdatedObj[key] = value
        internal.orgUpdatedObj = internal.orgUpdatedObj
    }

    function updateOrganization() {
        // console.log('Updating organization')
        if(!loggedUserPermissions.canEditOrganization)
            toast.error(qsTr("You don't have permissions to perform this task, contact org. admin for help."))

        var orgId = dsController.organization.id
        if(!orgId || orgId==='') {
            toast.error("Oops! Seems something is wrong here!")
            return
        }

        // Update Org
        var body = internal.orgUpdatedObj
        body['settings'] = internal.orgSettingsObj

        // Reset Request Data
        request.clear()
        request.body = body
        request.path = `/api/collections/organization/records/${orgId}`
        request.method = "PATCH"
        var res = request.send();

        if(res.status===200) {
            root.reloadOrganization()
            toast.success("Organization Updated!")
            internal.orgDetailsEdited = false
        }

        else if(res.status === 0) {
            toast.error("Could not connect to the server, check internet connection and try again!")
        }

        else {
            toast.error(res.data.message)
        }
    }
}
