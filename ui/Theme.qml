import QtQuick

Item {
    property bool isDarkTheme: false

    // property string primary: "#d1dbe4"
    // property string secondary: "#a3b7ca"
    // property string tertiary: "#7593af"
    // property string accent: "#476f95"
    // property string foreground: "#194a7a"

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

    property color overlayColor: Qt.rgba(53, 71, 104, 0.28)
    property color tooltipColor: Qt.rgba(0, 0, 0, 0.85)
    property color shadowColor: Qt.rgba(0, 0, 0, 0.06)
    
    property real appSidebarWidth: 75
    property real pageSidebarWidth: 235
    

    
    //     // https://developer.mozilla.org/en-US/docs/Web/CSS/accent-color
    //     accent-color: var(--primaryColor);
}

// :root {

// }

// property string baseFontFamily: 'Source Sans Pro', sans-serif, emoji;
// property string monospaceFontFamily: 'Ubuntu Mono', monospace, emoji;
// property string iconFontFamily: 'remixicon';

// property var baseAnimationSpeed: 150ms;
// property var activeAnimationSpeed: 70ms;
// property var entranceAnimationSpeed: 250ms;

// property var wrapperWidth:   850px;
// property var smWrapperWidth: 420px;
// property var lgWrapperWidth: 1200px;

// // Maps
// // ----
// $colorsMap: (
//     "primary":     var(--primaryColor),
//     "info":        var(--infoColor),
//     "info-alt":    var(--infoAltColor),
//     "success":     var(--successColor),
//     "success-alt": var(--successAltColor),
//     "danger":      var(--dangerColor),
//     "danger-alt":  var(--dangerAltColor),
//     "warning":     var(--warningColor),
//     "warning-alt": var(--warningAltColor),
// );

// $sidesMap: (
//     "t": "top",
//     "r": "right",
//     "b": "bottom",
//     "l": "left",
// );

// $sizesMap: (
//   "base": var(--baseSpacing),
//   "xs":   var(--xsSpacing),
//   "sm":   var(--smSpacing),
//   "lg":   var(--lgSpacing),
//   "xl":   var(--xlSpacing),
// );
