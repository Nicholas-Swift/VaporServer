//
//  SessionController.swift
//  VaporServer
//
//  Created by Nicholas Swift on 4/9/17.
//
//

import Vapor
import HTTP

class SessionController: ResourceRepresentable {
    
    // Create
    func create(request: Request) throws -> ResponseRepresentable {
         // take in username and password and create a session (jwtToken) and return
        return "jwtToken"
    }
    
}

// MARK: - Make Resource
extension SessionController {
    
    func makeResource() -> Resource<Post> {
        return Resource(
            store: create
        )
    }
    
}
