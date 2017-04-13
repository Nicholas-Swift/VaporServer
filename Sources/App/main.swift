import Vapor
import HTTP

// Init server
let drop = Droplet()

// Add all routes
Routing.addAllRoutes(to: drop)

// Run
drop.run()
