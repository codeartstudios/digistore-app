// Create a new suppply from the given data
routerAdd("POST", "/fn/create-supply", (e) => {
    var loggedUser = e.auth // empty if not authenticated as regular auth record

    // read/scan the request body fields into a typed object
    const data = new DynamicModel({
        amount: 0,
        supplier: "",
        organization: "",
        products: []
    })
    e.bindBody(data)

     // If `organization` is empty or does not matched logged in user organization
    // abort request.
    if (data.organization === "" || data.organization !== loggedUser.get('organization')) {
        return e.json(404, { status: 404, "message": "Organization not found!", data: {} })
    }

    var supply_record_saved = null;

    try {
        // Start a new transaction to encapsulate all db executions
        $app.runInTransaction((txDao) => {
            // Create a sale record
            let collection = txDao.findCollectionByNameOrId("supply")
            let supply_record = new Record(collection)

            // TODO add file support
            supply_record.set("organization", data.organization)
            supply_record.set("amount", data.amount)
            supply_record.set("products", data.products)
            supply_record.set("supplier", data.supplier)
            supply_record.set("teller", loggedUser.get('id'))

            // validate and persist sales record
            txDao.save(supply_record);
            supply_record_saved = supply_record; // Save the record

            // Update products with stock quantities
            for (var ind = 0; ind < data.products.length; ind++) {
                const item = data.products[ind]
                const product_record = txDao.findRecordById("product", item.id)

                if (!product_record.get("id")) throw { status: 404, message: `Item '${item.unit} ${item.name}' could not be found!`, data: {} }
               
                // TODO update bp, sp as well
                txDao.db()
                    .newQuery("UPDATE product SET stock = stock + {:qty} WHERE id = {:pid} and organization = {:org} ")
                    .bind({
                        "qty": item.quantity,
                        "pid": product_record.get("id"),
                        "org": loggedUser.get("organization")
                    }).execute()
            }
        })
    } catch (err) {
        return e.json(err.code ? err.code : 500, { "message": err.message ? err.message : "Something went wrong!", data: err })
    }

    return e.json(200, { code: 200, "message": "Supply record created", data: supply_record_saved })
}, $apis.requireAuth("tellers"))