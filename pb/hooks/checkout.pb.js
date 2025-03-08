
// Cart checkout endpoint
routerAdd("POST", "/fn/checkout", (e) => {
    const utils = require(`${__hooks}/utils.js`)

    var loggedUser = e.auth // empty if not authenticated as regular auth record
    const org = loggedUser.get("organization")

    // const data = e.requestInfo().body

    const data = new DynamicModel({
        totals: 0,
        payments: {},
        products: []
    })
    e.bindBody(data)

    // TODO
    // > Move organization auth to middleware
    if (!org || org === "") 
        return e.json(400, { status: 400, message: "Organization ID is required!", data: {}})
    
    const canSell = utils.hasPermission(loggedUser, "organization", "view") &&
        utils.hasPermission(loggedUser, "sales", "view") &&
        utils.hasPermission(loggedUser, "sales", "create") &&
        utils.hasPermission(loggedUser, "inventory", "view")

    if (!canSell) 
        return e.json(403, { status: 403, message: "Unauthorized to perform this task.", data: {}})

    if (!utils.recordExists("organization", org)) 
        return e.json(404, { "status": 404, message: "Organization with given ID does not exist.", data: {}})

    var saleRecordInDb = null;

    try {
        // Start a new transaction to encapsulate all db executions
        $app.runInTransaction((txDao) => {
            // Create a sale record
            let collection = txDao.findCollectionByNameOrId("sales")
            let salesRecord = new Record(collection)

            // TODO:
            //  -> Calculate profits from the sale transaction
            salesRecord.set("organization", org)
            salesRecord.set("totals", data.totals)
            salesRecord.set("payments", data.payments)
            salesRecord.set("teller", loggedUser.get("id"))
            salesRecord.set("discount", 0)
            salesRecord.set("profit", 0)

            // validate and persist sales record
            txDao.save(salesRecord);
            saleRecordInDb = salesRecord; // Save the record

            // Add sales items to database as well
            let saleitemsCollection = txDao.findCollectionByNameOrId("sale_items")
            let salesItemsRecord = new Record(saleitemsCollection)

            // Create sale_items record
            salesItemsRecord.set("organization",    org)
            salesItemsRecord.set("sales_id",        salesRecord.id)
            salesItemsRecord.set("products",        data.products)

            // Update products with stock quantities
            for (var ind = 0; ind < data.products.length; ind++) {
                const item = data.products[ind]
                const product_record = txDao.findRecordById("product", item.id)

                if (!product_record.get("id")) 
                    throw { status: 404, message: `Item '${item.unit} ${item.name}' could not be found!`, data: {} }
                
                if (!product_record.get("stock")) 
                    throw { status: 404, message: `'${item.unit} ${item.name}' not in stock anymore!`, data: {} }

                txDao.db()
                    .newQuery("UPDATE product SET stock = stock - {:qty} WHERE id = {:pid} and organization = {:org}")
                    .bind({
                        "qty": item.quantity,
                        "pid": product_record.get("id"),
                        "org": org
                    }).execute()
            }

            txDao.save(salesItemsRecord);
        })
    } catch (err) {
        console.log('Console Err: ', err, JSON.stringify(err))
        return e.json(err.status ? err.status : 500, err)
    }

    return e.json(200, saleRecordInDb )
}, $apis.requireAuth("tellers"))
