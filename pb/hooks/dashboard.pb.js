// Fetch total sales endpoint
routerAdd("GET", "/fn/dashboard/total-sales", (e) => {
              var loggedUser = e.auth // empty if not authenticated as regular auth record

              let oldStart = e.requestInfo().query["old_start"].trim()
              let newStart = e.requestInfo().query["new_start"].trim()
              let org = loggedUser.get('organization').trim()

              // If `organization` is empty or does not matched logged in user organization
              // abort request.
              if (org === "" || oldStart === "" || newStart === "") {
                  return e.json(400, { code: 400, "message": "Bad request, provide valid old_start and new_start query!" })
              }

              try {
                  const oldData = new DynamicModel({
                                                       "sum_totals": 0
                                                   })

                  const newData = new DynamicModel({
                                                       "sum_totals": 0
                                                   })

                  // NB:  To avoid converting NULL to int64 errors, we wrap both the SUM and `totals'
                  //      as `COALESCE(SUM(COALESCE(totals, 0)), 0)` ensuring if no data in period
                  //      or if `totals` is NULL, we return 0 for that case.

                  // Get SUM(totals) from the old date to the new date
                  $app.db()
                  .newQuery("SELECT COALESCE(SUM(COALESCE(totals, 0)), 0) as sum_totals FROM sales_view WHERE organization = {:org} and created >= {:from} and created < {:to}")
                  .bind({
                            "org": org,
                            "from": oldStart,
                            "to": newStart,
                        })
                  .one(oldData)

                  // Get SUM(totals) from the new date to current date
                  $app.db()
                  .newQuery("SELECT COALESCE(SUM(COALESCE(totals, 0)), 0) as sum_totals FROM sales_view WHERE organization = {:org} and created >= {:from}")
                  .bind({
                            "org": org,
                            "from": newStart
                        })
                  .one(newData)

                  return e.json(200, { value: newData.sum_totals, old_value: oldData.sum_totals })
              } catch (err) {
                  return e.json(500, { status: 500, error: err, data: {} })
              }
          }, $apis.requireAuth("tellers"))

// Fetch sales count endpoint
routerAdd("GET", "/fn/dashboard/completed-sales", (e) => {
              var loggedUser = e.auth // empty if not authenticated as regular auth record

              let oldStart = e.requestInfo().query["old_start"].trim()
              let newStart = e.requestInfo().query["new_start"].trim()
              let org = loggedUser.get('organization').trim()

              // If `organization` is empty or does not matched logged in user organization
              // abort request.
              if (org === "" || oldStart === "" || newStart === "") {
                  return e.json(400, { code: 400, "message": "Bad request, provide valid old_start and new_start query!" })
              }

              try {
                  const oldData = new DynamicModel({
                                                       "sales_count": 0
                                                   })

                  const newData = new DynamicModel({
                                                       "sales_count": 0
                                                   })

                  // NB:  To avoid converting NULL to int64 errors, we wrap both the SUM and `totals'
                  //      as `COALESCE(SUM(COALESCE(totals, 0)), 0)` ensuring if no data in period
                  //      or if `totals` is NULL, we return 0 for that case.

                  // Get COUNT(id) from the old date to the new date
                  $app.db()
                  .newQuery("SELECT COUNT(id) as sales_count FROM sales_view WHERE organization = {:org} and created >= {:from} and created < {:to}")
                  .bind({
                            "org": org,
                            "from": oldStart,
                            "to": newStart,
                        })
                  .one(oldData)

                  // Get COUNT(id) from the new date to current date
                  $app.db()
                  .newQuery("SELECT COUNT(id) as sales_count FROM sales_view WHERE organization = {:org} and created >= {:from}")
                  .bind({
                            "org": org,
                            "from": newStart
                        })
                  .one(newData)

                  return e.json(200, { value: newData.sales_count, old_value: oldData.sales_count })
              } catch (err) {
                  return e.json(500, { status: 500, error: err, data: {} })
              }
          }, $apis.requireAuth("tellers"))

// Fetch sales count endpoint
routerAdd("GET", "/fn/dashboard/stock-status", (e) => {
              var loggedUser = e.auth // empty if not authenticated as regular auth record

              let org = loggedUser.get('organization')

              // If `organization` is empty or does not matched logged in user organization
              // abort request.
              if (!org || org.trim() === "") {
                  return e.json(400, { code: 400, "message": "Bad request, user is not part of any organization!" })
              }

              // Remove any whitespaces
              org = org.trim()

              try {
                  const countData = new DynamicModel({
                                                         "product_count": 0
                                                     })
                  const zeroData = new DynamicModel({
                                                        "product_count": 0
                                                    })

                  // Get COUNT(id) from the old date to the new date
                  $app.db()
                  .newQuery("SELECT COUNT(id) as product_count FROM product WHERE organization = {:org}")
                  .bind({
                            "org": org
                        })
                  .one(countData)

                  // Get COUNT(id) from the new date to current date
                  $app.db()
                  .newQuery("SELECT COUNT(id) as product_count FROM product WHERE organization = {:org} and stock = 0")
                  .bind({
                            "org": org
                        })
                  .one(zeroData)

                  return e.json(200, { total_count: countData.product_count, zero_count: zeroData.product_count })
              } catch (err) {
                  return e.json(500, { status: 500, error: err, data: err })
              }
          }, $apis.requireAuth("tellers"))

// Fetch sales count endpoint
routerAdd("GET", "/fn/dashboard/low-stock", (e) => {
              var loggedUser = e.auth // empty if not authenticated as regular auth record

              let qty = e.requestInfo().query["threshold"]
              let org = loggedUser.get('organization').trim()

              // If `organization` is empty or does not matched logged in user organization
              // abort request.
              if (org === "") {
                  return e.json(400, { status: 400, error: "Bad request, no valid organization linked to user!", data: {} })
              }

              if (!qty || qty === "" || parseInt(qty) < 0 || isNaN(parseInt(qty))) {
                  return e.json(400, { status: 400, error: "Bad request, provide valid stock threshold value to the query!", data: {} })
              }

              qty = parseInt(qty)

              try {
                  const data = new DynamicModel({
                                                    "product_count": 0
                                                })

                  // Get COUNT(id) from the new date to current date
                  $app.db()
                  .newQuery("SELECT COUNT(id) as product_count FROM product WHERE organization = {:org} and stock <= {:qty}")
                  .bind({
                            "org": org,
                            "qty": qty
                        })
                  .one(data)

                  return e.json(200, { value: data.product_count })
              } catch (err) {
                  return e.json(500, { status: 500, error: err, data: {} })
              }
          }, $apis.requireAuth("tellers"))
