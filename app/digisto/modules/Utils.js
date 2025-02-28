function error(obj) {
    if(!obj) return qsTr("Unknown Error!")
    if(Object.keys(obj.data).includes('message')) {
        return obj.data.message
    }    
    if(Object.keys(obj.data).includes('error')) {
        return obj.data.message
    }
    return obj.error
}

function toSentenceCase(str) {
    return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
}

function maybeJSON(val) {
    if(!val) return '{}'
    try {
        var r = JSON.stringify(val)
        return r
    } catch(e) {
        return '!{}'
    }
}

function isUndefined(val) {
    if(typeof(val) === 'undefined') return true
    return false
}

function isNullOrUndefined(val) {
    return isUndefined(val) || val===null
}

function isValidDate(date) {
    // Check if it's an instance of Date and not an invalid date
    return date instanceof Date && !isNaN(date.getTime());
}

function startDateUTC(date=null) {
    if(!isValidDate(date)) date = new Date(Date.now())

    // Day starts at midnight, so, lets zero the hours, minutes, seconds and Milliseconds values
    date = new Date(date.getFullYear(), date.getMonth(), date.getDate(), 0, 0, 0, 0)

    return dateToUTCString(date)
}

function endDateUTC(date=null) {
    if(!isValidDate(date)) date = new Date(Date.now())

    // Day starts at midnight, so, lets zero the hours, minutes, seconds and Milliseconds values
    date = new Date(date.getFullYear(), date.getMonth(), date.getDate(), 23, 59, 59, 999)

    return dateToUTCString(date)
}

function dateToUTCString(date) {
    var dt = ''
    dt += date.getUTCFullYear().toString()
    dt += "-"
    dt += (date.getUTCMonth() + 1) < 10 ? `0${date.getUTCMonth() + 1}` : (date.getUTCMonth() + 1).toString()
    dt += "-"
    dt += date.getUTCDate() < 10 ? `0${date.getUTCDate()}` : date.getUTCDate().toString()
    dt += " "
    dt += date.getUTCHours() < 10 ? `0${date.getUTCHours()}` : date.getUTCHours().toString()
    dt += ":"
    dt += date.getUTCMinutes() < 10 ? `0${date.getUTCMinutes()}` : date.getUTCMinutes().toString()
    dt += ":"
    dt += date.getUTCSeconds() < 10 ? `0${date.getUTCSeconds()}` : date.getUTCSeconds().toString()
    dt += "."
    dt += date.getUTCMilliseconds() < 10 ?
                `00${date.getUTCMilliseconds()}` : date.getUTCMilliseconds() < 100 ?
                    `0${date.getUTCMilliseconds()}` : date.getUTCMilliseconds().toString()
    dt += "Z"

    return dt
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
    startDate.setMonth(today.getMonth() - 3); // Start from 3 months ago

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


function last7DaysDates() {
    const today = new Date();
    const sevenDaysAgo = new Date();
    const fourteenDaysAgo = new Date();

    sevenDaysAgo.setDate(today.getDate() - 7);
    fourteenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    return {
        'current': startDateUTC(sevenDaysAgo),
        'previous': startDateUTC(fourteenDaysAgo)
    }
}

function last30DaysDates() {
    const today = new Date();
    const thirtyDaysAgo = new Date();
    const sixtyDaysAgo = new Date();

    thirtyDaysAgo.setDate(today.getDate() - 30);
    sixtyDaysAgo.setDate(today.getDate() - 60);

    return {
        'current': startDateUTC(thirtyDaysAgo),
        'previous': startDateUTC(sixtyDaysAgo)
    }
}

function last3MonthsDates() {
    const today = new Date();
    const threeMonthsAgo = new Date();
    const sixMonthsAgo = new Date();

    threeMonthsAgo.setMonth(today.getMonth() - 3);
    sixMonthsAgo.setMonth(threeMonthsAgo.getMonth() - 3);

    return {
        'current': startDateUTC(threeMonthsAgo),
        'previous': startDateUTC(sixMonthsAgo)
    }
}

