

// Create greeting label and icon to match it
function getGreeting(date, Icon) {
    var hours = date.getHours()
    if(hours < 12)
        return { text: qsTr("Good Morning"), icon : Icon.sunset2}
    else if(hours < 16)
        return { text: qsTr("Good Afternoon"), icon : Icon.sun}
    else
        return { text: qsTr("Good Evening"), icon : Icon.moonStars}
}

// ---------------------------------------- //
// Fetch Functions                          //
// ---------------------------------------- //

function fetchDashboardCompletedSales(request, model) {
    var modelIndex = 1;     // Index of the model item to be modified
    const totalSales = model.get(modelIndex) // Fetch model at index 1

    // Fetch current and previous date cycle. i.e, past 7 days and 7 days before that
    var date = null
    if(totalSales.period === '3months')
        date = Utils.last3MonthsDates()

    else if(totalSales.period === '30days')
        date = Utils.last30DaysDates()

    else // 7days
        date = Utils.last7DaysDates()

    // Format date
    const currentDateCycleStart = Qt.formatDateTime(date.current, "yyyy-MM-dd 00:00:00.000Z")
    const previousDateCycleStart = Qt.formatDateTime(date.previous, "yyyy-MM-dd 00:00:00.000Z")
    const endpoint = `${dsController.workspaceId}/${previousDateCycleStart}/${currentDateCycleStart}`

    // Create and send GET request
    request.clear()
    request.path = `/fn/dashboard/completed-sales/${endpoint}`
    var res = request.send();

    if(res.status===200) {
        var data = res.data;
        model.setProperty(modelIndex, 'refValue',   data.old_value)
        model.setProperty(modelIndex, 'value',      data.value)
    }

    else {
        toast.error(res.data.message)
    }
}

function fetchDashboardStockStatus(request, model) {
    var modelIndex = 2;     // Index of the model item to be modified
    const endpoint = `${dsController.workspaceId}`

    // Create and send GET request
    request.clear()
    request.path = `/fn/dashboard/stock-status/${endpoint}`
    var res = request.send();

    if(res.status===200) {
        var data = res.data;
        var totals = data.total_count
        var zeroes = data.zero_count
        model.setProperty(modelIndex, 'refValue',   totals)
        model.setProperty(modelIndex, 'value',      totals-zeroes)
    }

    else {
        toast.error(res.data.message)
    }
}

function fetchDashboardLowStockStats(request, model) {
    var modelIndex = 3;     // Index of the model item to be modified
    var thresholdQty = 5    // Qty to check below it ...

    const endpoint = `${dsController.workspaceId}/${thresholdQty}`

    // Create and send GET request
    request.clear()
    request.path = `/fn/dashboard/low-stock/${endpoint}`
    var res = request.send();

    if(res.status===200) {
        var data = res.data;
        model.setProperty(modelIndex, 'value', data.value)
    }

    else {
        toast.error(res.data.message)
    }
}

function fetchDashboardTotalSalesSum(request, model) {
    var modelIndex = 0;     // Index of the model item to be modified
    const totalSales = model.get(modelIndex) // Fetch model at index 0

    // Fetch current and previous date cycle. i.e, past 7 days and 7 days before that
    var date = null
    if(totalSales.period === '3months')
        date = Utils.last3MonthsDates()

    else if(totalSales.period === '30days')
        date = Utils.last30DaysDates()

    else // 7days
        date = Utils.last7DaysDates()

    // Format date
    const currentDateCycleStart = Qt.formatDateTime(date.current, "yyyy-MM-dd 00:00:00.000Z")
    const previousDateCycleStart = Qt.formatDateTime(date.previous, "yyyy-MM-dd 00:00:00.000Z")
    const endpoint = `${dsController.workspaceId}/${previousDateCycleStart}/${currentDateCycleStart}`

    // Create and send GET request
    request.clear()
    request.path = `/fn/dashboard/total-sales/${endpoint}`
    var res = request.send();

    if(res.status===200) {
        var data = res.data;
        model.setProperty(modelIndex, 'refValue', data.old_value)
        model.setProperty(modelIndex, 'value', data.value)
    }

    else {
        toast.error(res.data.message)
    }
}

