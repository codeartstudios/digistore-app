

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
    const currentDateCycleStart = date.current
    const previousDateCycleStart = date.previous

    // Create and send GET request
    request.clear()
    request.path = `/fn/dashboard/completed-sales`
    request.query = {
        old_start: previousDateCycleStart,
        new_start: currentDateCycleStart
    }

    var res = request.send();

    if(res.status===200) {
        var data = res.data;
        model.setProperty(modelIndex, 'refValue',   data.old_value)
        model.setProperty(modelIndex, 'value',      data.value)
    }

    else {
        toast.error(toErrorString(res))
    }
}

function fetchDashboardStockStatus(request, model) {
    var modelIndex = 2;     // Index of the model item to be modified

    // Create and send GET request
    request.clear()
    request.path = `/fn/dashboard/stock-status`
    var res = request.send();

    if(res.status===200) {
        var data = res.data;
        var totals = data.total_count
        var zeroes = data.zero_count
        model.setProperty(modelIndex, 'refValue',   totals)
        model.setProperty(modelIndex, 'value',      totals-zeroes)
    }

    else {
        toast.error(toErrorString(res))
    }
}

function fetchDashboardLowStockStats(request, model) {
    var modelIndex = 3;     // Index of the model item to be modified
    var thresholdQty = 5    // Qty to check below it ...

    // Create and send GET request
    request.clear()
    request.path = `/fn/dashboard/low-stock`
    request.query = {
        threshold: thresholdQty
    }

    var res = request.send();

    if(res.status===200) {
        var data = res.data;
        model.setProperty(modelIndex, 'value', data.value)
    }

    else {
        toast.error(toErrorString(res))
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
    const currentDateCycleStart = date.current
    const previousDateCycleStart = date.previous

    // Create and send GET request
    request.clear()
    request.path = `/fn/dashboard/total-sales`
    request.query = {
        old_start: previousDateCycleStart,
        new_start: currentDateCycleStart
    }

    var res = request.send();

    if(res.status===200) {
        var data = res.data;
        model.setProperty(modelIndex, 'refValue', data.old_value)
        model.setProperty(modelIndex, 'value', data.value)
    }

    else {
        toast.error(toErrorString(res))
    }
}

function fetchDashboardLast10Sales(request, model) {
    var query = {
        page: 1,
        perPage: 10,
        expand: "teller",
        fields: "*,expand.teller.name",
        sort: `-created`, // DESC newest -> oldest
        filter: `organization='${dsController.workspaceId}'`
    }

    request.clear()
    request.query = query;
    var res = request.send();

    if(res.status===200) {
        model.clear()
        var data = res.data.items;
        var items = []

        try {
            data.forEach(
                        function(p, index) {
                            var obj = {}
                            obj['date'] =  p.created ? Qt.formatDateTime(new Date(p.created), 'ddd MMM d, yyyy hh:mm AP') : qsTr('n.d')

                            var payments = []
                            const keys = p.payments ? Object.keys(p.payments) : []
                            for(var i=0; i<keys.length; i++) {
                                var a = p.payments[keys[i]]  // Maybe NULL
                                const amount =  (a && a.amount) ? a.amount : 0
                                if(amount > 0) {
                                    var q = p.payments[keys[i]]
                                    q = (q && q.label) ? q.label : qsTr("<?>")
                                    payments.push(q.toString())
                                }
                            }

                            obj['payments'] = payments.length>0 ? payments.join(', ') : qsTr('N/A')
                            obj['teller']   = (p.teller && p.expand) ? p.expand.teller.name : ''
                            obj['totals']   = p.totals ? p.totals : 0
                            obj['items']    = 0
                            model.append(obj)
                        });
        }

        catch(err) {
            toast.warning(qsTr("We encountered an error!") + '\n' + err);
        }
    }

    else if(res.status === 0) {
        toast.error(qsTr("Could not connect to the server, something isn't right!"))
    }

    else if(res.status === 403) {
        toast.error(qsTr("You don't seem to have access rights to perform this action."))
    }

    else {
        toast.error(Utils.error(res))
    }
}
