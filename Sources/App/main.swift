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
        
        /*
         * Secured Endpoints
         * Anything in here requires the Authorication header:
         * Example: "Authorization: Bearer TOKEN"
         */
        let protect = ProtectMiddleware(error: Abort.custom(status: .unauthorized, message: "Unauthorized"))
        v1.group(BearerAuthMiddleware(), protect) { secured in
            
            let users = secured.grouped("users")
            
            /*
             * Me
             * Get the current users info
             */
            users.get("me", handler: usersController.me)
            
            /*
             * Log out
             */
//            users.post("logout", handler: usersController.logout)
        }
        
    }
    
}

// Run
drop.run()
