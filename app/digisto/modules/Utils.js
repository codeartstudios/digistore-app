
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
