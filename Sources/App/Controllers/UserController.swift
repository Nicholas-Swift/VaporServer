//
//  UserController.swift
//  VaporServer
//
//  Created by Nicholas Swift on 4/9/17.
//
//

import Vapor
import HTTP

class UserController: ResourceRepresentable {
    
    // Create
    func create(request: Request) throws -> ResponseRepresentable {
        var user = try request.createUser()
        try user.save()
        return user
    }
    
    // Show
    func show(request: Request, user: User) throws -> ResponseRepresentable {
        return user
    }
    
    // Show me
    func showMe(user: User) throws -> ResponseRepresentable {
        
        // Get the auth token and return the user from the jwt token
        
        return user
    }
    
}

// MARK: - Make Resource
extension UserController {
    
    func makeResource() -> Resource<User> {
        return Resource(
            store: create,
            show: show
        )
    }
    
}

// MARK: - User Request Extension
extension Request {
    
    func createUser() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        return try User(node: json)
    }
    
}
