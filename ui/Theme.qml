import QtQuick

Item {
    property bool isDarkTheme: false

    property string primary: isDarkTheme ? dark.primary : light.primary
    property string secondary: isDarkTheme ? dark.secondary : light.secondary
    property string tertiary: isDarkTheme ? dark.tertiary : light.tertiary
    property string accent: isDarkTheme ? dark.accent : light.accent
    property string foreground: isDarkTheme ? dark.foreground : light.foreground

    // QtObject {
    //     id: dark
    //     property string primary: "#433741" //
    //     property string secondary: "#69696B"
    //     property string tertiary: "#A9A8A9"
    //     property string accent: "#DAD7D2"
    //     property string foreground: "#C9A276"
    // }

    QtObject {
        id: dark
        property string primary: "#0D1B2A"
        property string secondary: "#1B263B"
        property string tertiary: "#415A77"
        property string accent: "#778DA9"
        property string foreground: "#778DA9"
    }

    QtObject {
        id: light
        property string primary: "#d1dbe4"
        property string secondary: "#a3b7ca"
        property string tertiary: "#7593af"
        property string accent: "#476f95"
        property string foreground: "#194a7a"
    }

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
}

// :root {
//     --baseFontFamily: 'Source Sans Pro', sans-serif, emoji;
//     --monospaceFontFamily: 'Ubuntu Mono', monospace, emoji;
//     --iconFontFamily: 'remixicon';

//     --txtPrimaryColor:  #16161a;
//     --txtHintColor:     #666f75;
//     --txtDisabledColor: #a0a6ac;

//     --primaryColor: #16161a;

//     --bodyColor: #f8f9fa;

//     --baseColor:     #ffffff;
//     --baseAlt1Color: #e4e9ec;
//     --baseAlt2Color: #d7dde4;
//     --baseAlt3Color: #c6cdd7;
//     --baseAlt4Color: #a5b0c0;

//     --infoColor:       #5499e8;
//     --infoAltColor:    #cee2f8;
//     --successColor:    #32ad84;
//     --successAltColor: #c4eedc;
//     --dangerColor:     #e34562;
//     --dangerAltColor:  #f7cad2;
//     --warningColor:    #ff944d;
//     --warningAltColor: #ffd4b8;

//     --overlayColor:   rgba(53, 71, 104, 0.28);
//     --tooltipColor:   rgba(0, 0, 0, 0.85);
//     --shadowColor:    rgba(0, 0, 0, 0.06);

//     --baseFontSize: 14.5px;
//     --xsFontSize:   12px;
//     --smFontSize:   13px;
//     --lgFontSize:   15px;
//     --xlFontSize:   16px;

//     --baseLineHeight: 22px;
//     --smLineHeight:   16px;
//     --lgLineHeight:   24px;

//     --inputHeight: 34px;

//     --btnHeight:   40px;
//     --xsBtnHeight: 22px;
//     --smBtnHeight: 30px;
//     --lgBtnHeight: 54px;

//     --baseSpacing: 30px;
//     --xsSpacing:   15px;
//     --smSpacing:   20px;
//     --lgSpacing:   50px;
//     --xlSpacing:   60px;

//     --wrapperWidth:   850px;
//     --smWrapperWidth: 420px;
//     --lgWrapperWidth: 1200px;

//     --appSidebarWidth: 75px;
//     --pageSidebarWidth: 235px;

//     --baseAnimationSpeed: 150ms;
//     --activeAnimationSpeed: 70ms;
//     --entranceAnimationSpeed: 250ms;

//     // https://developer.mozilla.org/en-US/docs/Web/CSS/accent-color
//     accent-color: var(--primaryColor);
// }


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
