// Ping endpoint, used for testing server is running
// Alternatively, use the pb /health endpoint
routerAdd("GET", "/fn/ping", (e) => {
              return e.json(200, { "message": "Pong!" })
          })
