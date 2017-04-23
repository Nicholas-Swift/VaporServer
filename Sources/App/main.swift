import Vapor
import HTTP
import VaporPostgreSQL
import Auth

// Init server
let drop = Droplet(
    preparations: [User.self],
    providers: [VaporPostgreSQL.Provider.self]
)

drop.middleware.append(AuthMiddleware<User>())

// Add all routes
drop.group("api") { api in
    api.group("v1") { v1 in
        
        let usersController = UsersController()
        
        /*
         * /users
         * Create a new Username and Password to receive an authorization token and account
         */
        v1.post("users", handler: usersController.create)
        
    }
    
}

// Run
drop.run()
