import Vapor
import HTTP
import VaporPostgreSQL
import Auth

// Init server
let drop = Droplet(
    preparations: [User.self, Post.self],
    providers: [VaporPostgreSQL.Provider.self]
)

drop.middleware.append(AuthMiddleware<User>())

// Add all routes
drop.group("api") { api in
    api.group("v1") { v1 in
        
        let usersController = UsersController()
        let postsController = PostsController()
        let storiesController = StoriesController()
        
        /*
         * /users
         * Create a new Username and Password to receive an authorization token and account
         */
        v1.post("users", handler: usersController.create)
        
        v1.get("stories", handler: storiesController.stories)
        
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
            
            
            /*
             * /posts
             * Create a new post by passing in all the relevant data
             */
            secured.post("posts", handler: postsController.create)
        }
        
    }
    
}

// Run
drop.run()
