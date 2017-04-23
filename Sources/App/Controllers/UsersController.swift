//
//  UserController.swift
//  VaporServer
//
//  Created by Nicholas Swift on 4/9/17.
//
//

import Foundation
import Vapor
import HTTP
import Turnstile
import TurnstileCrypto
import TurnstileWeb
import JWT

class UsersController {
    
    // MARK: Authentication
    
    func create(request: Request) throws -> ResponseRepresentable {
        // Get our credentials
        guard let password = request.data["password"]?.string else {
            throw Abort.custom(status: Status.badRequest, message: "Missing password")
        }
        let credentials = PasswordCredentials(password: password)
        
        // Try to register the user
        do {
            let newUser = try User.register(credentials: credentials)
            credentials.username = try newUser.makeNode()["username"]!.string!
            try request.auth.login(credentials)
            
            // Get the current signed-in user's ID
            guard let user = try? request.user(), let userId = user.id?.int else {
                throw Abort.custom(status: .unauthorized, message: "Please re authenticate")
            }
            
            // Gernare our token with the User ID
            let payload = Node([ExpirationTimeClaim(Seconds(Authentication.Length)), SubjectClaim("\(userId)")])
            let jwt = try JWT(payload: payload, signer: HS256(key: Authentication.AccessTokenSigningKey.makeBytes()))
            
            return try JSON(node: ["success": true, "user": request.user().makeNode(), "token": jwt.createToken()])
        } catch let e as TurnstileError {
            throw Abort.custom(status: Status.badRequest, message: e.description)
        }
    }
    
    
    // me
    func me(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: request.user().makeNode())
    }
    
    // Show
//    func show(request: Request, user: User) throws -> ResponseRepresentable {
//        return user as! ResponseRepresentable
//    }
//    
//    // Show me
//    func showMe(user: User) throws -> ResponseRepresentable {
//        
//        // Get the auth token and return the user from the jwt token
//        
//        return user as! ResponseRepresentable
//    }
    
}

// MARK: - User Request Extension
extension Request {
    
    // Helper method to get the current user
    func user() throws -> User {
        guard let user = try auth.user() as? User else {
            throw UnsupportedCredentialsError()
        }
        return user
    }
    
    // Base URL returns the hostname, scheme, and port in a URL string form. (?idk)
    var baseURL: String {
        return uri.scheme + "://" + uri.host + (uri.port == nil ? "" : ":\(uri.port!)")
    }
    
    // Exposes the Turnstile subject, as Vapor has a facade on it. (?idk)
    var subject: Subject {
        return storage["subject"] as! Subject
    }
}
