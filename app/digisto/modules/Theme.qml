pragma Singleton
import QtQuick

Item {
    property string txtPrimaryColor:    dsController.isDarkTheme ? dark.txtPrimaryColor : light.txtPrimaryColor
    property string txtHintColor:       dsController.isDarkTheme ? dark.txtHintColor : light.txtHintColor
    property string txtDisabledColor:   dsController.isDarkTheme ? dark.txtDisabledColor : light.txtDisabledColor

    property string primaryColor:       dsController.isDarkTheme ? dark.primaryColor : light.primaryColor
    property string bodyColor:          dsController.isDarkTheme ? dark.bodyColor : light.bodyColor

    property string baseColor:          dsController.isDarkTheme ? dark.baseColor : light.baseColor
    property string baseAlt1Color:      dsController.isDarkTheme ? dark.baseAlt1Color : light.baseAlt1Color
    property string baseAlt2Color:      dsController.isDarkTheme ? dark.baseAlt2Color : light.baseAlt2Color
    property string baseAlt3Color:      dsController.isDarkTheme ? dark.baseAlt3Color : light.baseAlt3Color
    property string baseAlt4Color:      dsController.isDarkTheme ? dark.baseAlt4Color : light.baseAlt4Color

    property string infoColor:          dsController.isDarkTheme ? dark.infoColor : light.infoColor
    property string infoAltColor:       dsController.isDarkTheme ? dark.infoAltColor : light.infoAltColor
    property string successColor:       dsController.isDarkTheme ? dark.successColor : light.successColor
    property string successAltColor:    dsController.isDarkTheme ? dark.successAltColor : light.successAltColor
    property string dangerColor:        dsController.isDarkTheme ? dark.dangerColor : light.dangerColor
    property string dangerAltColor:     dsController.isDarkTheme ? dark.dangerAltColor : light.dangerAltColor
    property string warningColor:       dsController.isDarkTheme ? dark.warningColor : light.warningColor
    property string warningAltColor:    dsController.isDarkTheme ? dark.warningAltColor : light.warningAltColor

    property color overlayColor:        dsController.isDarkTheme ? dark.overlayColor : light.overlayColor
    property color tooltipColor:        dsController.isDarkTheme ? dark.tooltipColor : light.tooltipColor
    property color shadowColor:         dsController.isDarkTheme ? dark.shadowColor : light.shadowColor

    property real h1:               22 // px
    property real h1LineHeight:     28 // px

    property real h2:               20 // px
    property real h2LineHeight:     26 // px

    property real h3:               19 // px
    property real h3LineHeight:     24 // px

    property real h4:               18 // px
    property real h4LineHeight:     24 // px

    property real h5:               17 // px
    property real h5LineHeight:     24 // px

    property real h6:               16 // px
    property real h6LineHeight:     22 // px


    // dimensions
    property real baseFontSize:     14.5 // px
    property real xsFontSize:       12 // px
    property real smFontSize:       13 // px
    property real lgFontSize:       15 // px
    property real xlFontSize:       16 // px

    property real baseLineHeight:   22 // px
    property real smLineHeight:     16 // px
    property real lgLineHeight:     24 // px

    property real inputHeight:      34 // px

    property real btnHeight:        40 // px
    property real xsBtnHeight:      22 // px
    property real smBtnHeight:      30 // px
    property real lgBtnHeight:      54 // px

    property real baseSpacing:      30 // px
    property real xsSpacing:        15 // px
    property real smSpacing:        20 // px
    property real lgSpacing:        50 // px
    property real xlSpacing:        60 // px

    property real baseRadius:       4   // px
    property real lgRadius:         12  // px
    property real btnRadius:        4   // px

    property real appSidebarWidth:  75
    property real pageSidebarWidth: 235

    property real wrapperWidth:     850     // px
    property real smWrapperWidth:   420     // px
    property real lgWrapperWidth:   1200    // px

    // https://developer.mozilla.org/en-US/docs/Web/CSS/accent-color
    // accent-color: var(--primaryColor);

    QtObject {
        id: light

        property string txtPrimaryColor:    "#16161a"
        property string txtHintColor:       "#666f75"
        property string txtDisabledColor:   "#a0a6ac"

        property string primaryColor:       "#16161a"
        property string bodyColor:          "#f8f9fa"

        property string baseColor:          "#ffffff"
        property string baseAlt1Color:      "#e4e9ec"
        property string baseAlt2Color:      "#d7dde4"
        property string baseAlt3Color:      "#c6cdd7"
        property string baseAlt4Color:      "#a5b0c0"

        property string infoColor:          "#5499e8"
        property string infoAltColor:       "#cee2f8"
        property string successColor:       "#32ad84"
        property string successAltColor:    "#c4eedc"
        property string dangerColor:        "#e34562"
        property string dangerAltColor:     "#f7cad2"
        property string warningColor:       "#ff944d"
        property string warningAltColor:    "#ffd4b8"

        property color overlayColor:    Qt.rgba(53, 71, 104, 0.28)
        property color tooltipColor:    Qt.rgba(0, 0, 0, 0.85)
        property color shadowColor:     Qt.rgba(0, 0, 0, 0.06)
    }

    QtObject {
        id: dark

        property string txtPrimaryColor:    "#e0e0e0"
        property string txtHintColor:       "#a0a6ac"
        property string txtDisabledColor:   "#666f75"

        property string primaryColor:       "#f8f9fa"

        property string bodyColor:          "#121212"

        property string baseColor:          "#1e1e1e"
        property string baseAlt1Color:      "#292a2d"
        property string baseAlt2Color:      "#323338"
        property string baseAlt3Color:      "#3b3d42"
        property string baseAlt4Color:      "#4d5159"

        property string infoColor:          "#5499e8"
        property string infoAltColor:       "#2a4974"
        property string successColor:       "#32ad84"
        property string successAltColor:    "#1c5e4b"
        property string dangerColor:        "#e34562"
        property string dangerAltColor:     "#75202f"
        property string warningColor:       "#ff944d"
        property string warningAltColor:    "#7a3d1a"

        property color overlayColor:    Qt.rgba(15, 20, 30, 0.6)
        property color tooltipColor:    Qt.rgba(255, 255, 255, 0.85)
        property color shadowColor:     Qt.rgba(0, 0, 0, 0.3)
    }
}
