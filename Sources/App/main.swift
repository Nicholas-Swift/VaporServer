import Vapor
import HTTP

// Init server
let drop = Droplet(
    preparations: [User.self]
)

// Add all routes
Routing.addAllRoutes(to: drop)

// Run
drop.run()
