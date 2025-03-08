
const permissionTemplate = {
    "admin": {
        "organization": ["view", "update", "delete"],
        "user_accounts": ["view", "create", "update", "delete"],
        "suppliers": ["view", "create", "update", "delete"],
        "supply": ["view", "create", "update", "delete"],
        "inventory": ["view", "create", "update", "delete"],
        "sales": ["view", "create", "update", "delete"]
    },
    "manager": {
        "organization": ["view", "update"],
        "user_accounts": ["view"],
        "suppliers": ["view", "create", "update"],
        "supply": ["view", "create", "update"],
        "inventory": ["view", "create", "update"],
        "sales": ["view", "create", "update", "delete"]
    },
    "cashier": {
        "organization": ["view"],
        "sales": ["view", "create"],
        "inventory": ["view"]
    },
    "stock_manager": {
        "organization": ["view"],
        "suppliers": ["view"],
        "supply": ["view", "create", "update"],
        "inventory": ["view", "create", "update"]
    }
}

module.exports = {
    recordExists: (table, recordId) => {
        try { $app.findRecordById(table, recordId); return true }
        catch (err) { return false }
    },
    hasPermission: (user, _collection, _action) => {
        // Extract the role and overrides
        const role = user.get('role')
        const overrides = JSON.parse(user.get('overrides'))

        // Format input values
        const collection = _collection.trim().toLowerCase()
        const action = _action.trim().toLowerCase()

        // Check if the inputs are null
        if (role === '' || collection === '' || action === '')
            return false

        try {
            // Get all keys
            const keys = Object.keys(permissionTemplate)
            if (!keys.includes(role))
                return false

            var p = permissionTemplate[role]
            const col = p[collection]
            if (col.includes(action))
                return true;

            // Check if 'overrides' is null
            if (JSON.stringify(overrides) === 'null')
                return false

            if (overrides[collection].includes(action)) {
                return true;
            }
        } catch (e) {
            return false
        }
    }
}