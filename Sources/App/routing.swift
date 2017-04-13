//
//  routing.swift
//  VaporServer
//
//  Created by Nicholas Swift on 4/9/17.
//
//

import Vapor
import HTTP

struct Routing {
    
    static func addAllRoutes(to drop: Droplet) {
        drop.resource("main", MainController())
        drop.resource("post", PostController())
        // drop.resource("user", UserController())
    }
    
}
