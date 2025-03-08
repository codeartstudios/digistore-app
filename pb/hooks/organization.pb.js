
// Create an orgnanization
routerAdd("POST", "/fn/create-organization", (e) => {
    var loggedUser = e.auth // Get authenticated user

    // read/scan the request body fields into a typed object
    const data = new DynamicModel({
        name: "",
        workspace: "",
        approved: true
    })
    e.bindBody(data)

    // Check if both name or workspace is provided
    if(data.name==="" || data.workspace==="") {
        return e.json(400, { "status": 400, "message": "Missing required value!", data: {} })
    }

    // Check if a record exists with that workspace id
    const records = $app.findAllRecords("organization",
        $dbx.exp("workspace = {:workspace}", { "workspace": data.workspace }),
    )

    if(records.length>0) {
        return e.json(404, { "status": 404, "message": "Workspace ID is not available!", data: {} })
    }

    var updated_user = null

    try {
        const collection = $app.findCollectionByNameOrId("organization")

        // Start a new transaction to encapsulate all db executions
        $app.runInTransaction((txDao) => {
            // Create an organization record
            let org_record = new Record(collection)
            org_record.set("name", data.name.trim())
            org_record.set("workspace", data.workspace.trim())
            org_record.set("approved", data.approved)
            org_record.set("account_completed", false)
            org_record.set("settings", {
                currency: 'usd',
                screen_timeout_enabled: false,
                users_can_delete_own_accounts: false
            })

            // validate and persist sales record
            txDao.save(org_record);

            var user_record = $app.findRecordById("tellers", loggedUser.id)

            user_record.set("organization", org_record.id)
            user_record.set("is_admin", true)   // Set as orgnaization account

            txDao.save(user_record);

            user_record.set('expand', {
                organization: org_record
            })

            updated_user = {
                record: user_record
            }
        })
    } 
    
    catch (err) {
        console.log('[Organization] > Hook Error: ', err)
        const code = err.code ? err.code : 500
        return e.json(code, { status: code, message: err, data: {} })
    }

    return e.json(200, updated_user )
}, $apis.requireAuth("tellers"))
