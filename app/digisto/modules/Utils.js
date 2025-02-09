
function isValidDate(date) {
    // Check if it's an instance of Date and not an invalid date
    return date instanceof Date && !isNaN(date.getTime());
}

// Converts a local date to UTC equivalent
function dateToUTC(date, flag="zero") {
    // Check that date is valid
    if(!isValidDate(date)) return ""

    switch(flag) {
    case "zero": { // Zeroes seconds/milliseconds
        date.setSeconds(0)
        date.setMilliseconds(0)
        break;
    }
    case "max": { // Sets seconds/milliseconds to Max value
        date.setSeconds(59)
        date.setMilliseconds(999)
        break;
    }
    default: {
        // Use date as is
    }
    }

    return date.toISOString().replace("T", " ")
}

function withOpacity(color, opacity) {
    var r, g, b;

    if(!color) return "#000"

    // Named color
    if (color.startsWith("#")) {
        if (color.length === 7) { // #RRGGBB
            r = parseInt(color.substr(1, 2), 16) / 255.0;
            g = parseInt(color.substr(3, 2), 16) / 255.0;
            b = parseInt(color.substr(5, 2), 16) / 255.0;
        } else if (color.length === 4) { // #RGB
            r = parseInt(color.substr(1, 1) + color.substr(1, 1), 16) / 255.0;
            g = parseInt(color.substr(2, 1) + color.substr(2, 1), 16) / 255.0;
            b = parseInt(color.substr(3, 1) + color.substr(3, 1), 16) / 255.0;
        }
    } else if (color.startsWith("rgb")) {
        var rgbValues = color.match(/\d+/g);
        r = rgbValues[0] / 255.0;
        g = rgbValues[1] / 255.0;
        b = rgbValues[2] / 255.0;
    } else {
        // If it's a named color
        var tmpColor = Qt.color(color);
        r = tmpColor.r;
        g = tmpColor.g;
        b = tmpColor.b;
    }

    return Qt.rgba(r, g, b, opacity);
}

// https://stackoverflow.com/a/65425828
function isJSONEqual(obj1,obj2) {
    var obj1keys = Object.keys(obj1);
    var obj2keys = Object.keys(obj2);

    //return true when the two json has same length
    // and all the properties has same value key by key
    return obj1keys.length === obj2keys.length &&
            Object.keys(obj1).every(key=>obj1[key]===obj2[key]);
}

// Commafy number in thousands.
// ie, given 12345 -> 12,345
function commafy(value) {
    return value.toLocaleString()
}
