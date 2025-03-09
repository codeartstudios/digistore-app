// pb_migrations/1687801090_initial_superuser.js

migrate((app) => {
            let superusers = app.findCollectionByNameOrId("_superusers")

            let record = new Record(superusers)

            // note: the values can be eventually loaded via $os.getenv(key)
            // or from a special local config file
            record.set("email", "_admin@digisto.app")
            record.set("password", "1234567890")

            app.save(record)
        }, (app) => { // optional revert operation
            try {
                let record = app.findAuthRecordByEmail("_superusers", "_admin@digisto.app")
                app.delete(record)
            } catch {
                // silent errors (probably already deleted)
            }
        })
