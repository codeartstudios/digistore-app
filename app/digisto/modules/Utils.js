
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

// Date Range Calculations
function last7Days() {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    const suffixes = ['th', 'st', 'nd', 'rd'];

    function getDaySuffix(day) {
        if (day >= 11 && day <= 13) return 'th'; // Special case for 11th, 12th, 13th
        return suffixes[day % 10] || 'th';
    }

    const result = [];
    const today = new Date();

    for (let i = 6; i >= 0; i--) {
        const date = new Date();
        date.setDate(today.getDate() - i);

        const dayOfWeek = days[date.getDay()];
        const dayOfMonth = date.getDate();
        const suffix = getDaySuffix(dayOfMonth);

        if (i === 0) {
            result.push('Today');
        } else if (i === 1) {
            result.push('Yesterday');
        } else {
            result.push(`${dayOfWeek}, ${dayOfMonth}${suffix}`);
        }
    }

    return result;
}

function last30Days() {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const suffixes = ['th', 'st', 'nd', 'rd'];

    function getDaySuffix(day) {
        if (day >= 11 && day <= 13) return 'th'; // Special case for 11th, 12th, 13th
        return suffixes[day % 10] || 'th';
    }

    const result = [];
    const today = new Date();
    let lastMonth = today.getMonth(); // Track the last month seen

    for (let i = 29; i >= 0; i--) {
        const date = new Date();
        date.setDate(today.getDate() - i);

        const month = months[date.getMonth()];
        const dayOfMonth = date.getDate();
        const suffix = getDaySuffix(dayOfMonth);

        let formattedDate;
        if (i === 0) {
            formattedDate = 'Today';
        } else if (i === 1) {
            formattedDate = 'Yesterday';
        } else if (date.getMonth() !== lastMonth) {
            formattedDate = `${month} ${dayOfMonth}${suffix}`;
            lastMonth = date.getMonth(); // Update last seen month
        } else {
            formattedDate = `${dayOfMonth}${suffix}`;
        }

        result.push(formattedDate);
    }

    return result;
}

function last3Months() {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const suffixes = ['th', 'st', 'nd', 'rd'];

    function getDaySuffix(day) {
        if (day >= 11 && day <= 13) return 'th'; // Special case for 11th, 12th, 13th
        return suffixes[day % 10] || 'th';
    }

    const result = [];
    const today = new Date();
    const startDate = new Date();
    startDate.setMonth(today.getMonth() - 2); // Start from 3 months ago

    let lastMonth = null; // Ensure the first month always has a prefix

    while (startDate <= today) {
        const month = months[startDate.getMonth()];
        const dayOfMonth = startDate.getDate();
        const suffix = getDaySuffix(dayOfMonth);

        let formattedDate;
        if (
                startDate.getDate() === today.getDate() &&
                startDate.getMonth() === today.getMonth() &&
                startDate.getFullYear() === today.getFullYear()
                ) {
            formattedDate = 'Today';
        } else if (
                   startDate.getDate() === today.getDate() - 1 &&
                   startDate.getMonth() === today.getMonth() &&
                   startDate.getFullYear() === today.getFullYear()
                   ) {
            formattedDate = 'Yesterday';
        } else if (startDate.getMonth() !== lastMonth || lastMonth === null) {
            formattedDate = `${month} ${dayOfMonth}${suffix}`;
            lastMonth = startDate.getMonth(); // Update last displayed month
        } else {
            formattedDate = `${dayOfMonth}${suffix}`;
        }

        result.push(formattedDate);
        startDate.setDate(startDate.getDate() + 1); // Move to next day
    }

    return result;
}

