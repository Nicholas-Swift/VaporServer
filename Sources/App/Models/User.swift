//
//  User.swift
//  VaporServer
//
//  Created by Nicholas Swift on 4/9/17.
//
//

import Foundation
import Vapor
import Auth
import Turnstile
import TurnstileCrypto
import JWT
//import Core

struct Authentication {
    static let AccessTokenSigningKey = "secret"
    static let Length = 60 * 2592000 // 30 days later
}

final class User: Auth.User {
    
    // MARK: - Instance Variables
    static var currentUsernames: Set<String> = Set()
    var id: Node?
    var exists: Bool = false
    
    var username: String
    var password: String
    var lastPostedAt: Date?
    
    var createdAt: Date
    var updatedAt: Date
    
    // MARK: - Inits
    init(password: String) {
        self.username = User.generateUsername()
        self.password = BCrypt.hash(password: password)
        self.createdAt = Date()
        self.updatedAt = Date()
        self.lastPostedAt = nil
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        username = try node.extract("username")
        password = try node.extract("password")
        let lastPostedAtString: String? = try? node.extract("last_posted_at")
        lastPostedAt = lastPostedAtString?.hsfToDate()
        
        let createdAtString: String = try node.extract("created_at"); createdAt = createdAtString.hsfToDate()!
        let updatedAtString: String = try node.extract("updated_at"); updatedAt = updatedAtString.hsfToDate()!
    }
    
    init(credentials: PasswordCredentials) {
        self.username = User.generateUsername()
        self.password = BCrypt.hash(password: credentials.password)
        self.createdAt = Date()
        self.updatedAt = Date()
        self.lastPostedAt = nil
    }
}

// MARK: - Authentication
extension User {
    
    // Authenticate user with credentials
    @discardableResult
    static func authenticate(credentials: Credentials) throws -> Auth.User {
        var user: User?
        
        switch credentials {
        case let credentials as PasswordCredentials:
            let fetchedUser = try User.query().filter("username", credentials.username).first()
            if let password = fetchedUser?.password, password != "", (try? BCrypt.verify(password: credentials.password, matchesHash: password)) == true {
                user = fetchedUser
            }
            
        case let credentials as Auth.AccessToken:
            // Verify the token
            let receivedJWT = try JWT(token: credentials.string)
            
            // Verify the token
            try receivedJWT.verifySignature(using: HS256(key: Authentication.AccessTokenSigningKey.makeBytes()))
            if receivedJWT.verifyClaims([ExpirationTimeClaim(Seconds(Authentication.Length))]) {
                guard let userId = receivedJWT.payload.object?[SubjectClaim.name]?.string else { throw IncorrectCredentialsError() }
                user = try User.query().filter("id", userId).first()
            } else {
                throw IncorrectCredentialsError()
            }
            
        default: throw UnsupportedCredentialsError()
        }
        
        guard let guardedUser = user else { throw IncorrectCredentialsError() }
        return guardedUser
    }
    
    // Register a user with credentials
    @discardableResult
    static func register(credentials: Credentials) throws -> Auth.User {
        var newUser: User

        switch credentials {
        case let credentials as PasswordCredentials:
            newUser = User(credentials: credentials)
            
        default: throw UnsupportedCredentialsError()
        }
        
        if try User.query().filter("username", newUser.username).first() == nil {
            try newUser.save()
            return newUser
        } else {
            throw AccountTakenError()
        }
        
    }
    
}

// MARK: - Node Representable
extension User: NodeRepresentable {
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": self.id?.makeNode(),
            
            "username": self.username.makeNode(),
            "password": self.password.makeNode(),
            "last_posted_at": self.lastPostedAt == nil ? .null : self.lastPostedAt!.hsfToString().makeNode(),
            
            "created_at": self.createdAt.hsfToString().makeNode(),
            "updated_at": self.updatedAt.hsfToString().makeNode()
            ])
    }
}

// MARK: - Database
extension User {
    
    static func prepare(_ database: Database) throws {
        try database.create("users") { users in
            users.id()
            users.string("username")
            users.string("password")
            users.string("last_posted_at", optional: true)
            users.string("created_at")
            users.string("updated_at")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("users")
    }
}

// MARK: - Username Creation
extension User {
    
    fileprivate static func generateUsername() -> String {
        
        // Generate new username
        var newUsername = Usernames.adjectives.randomItem() + Usernames.nouns.randomItem()
        
        // Keep rerolling until unique
        while User.currentUsernames.contains(newUsername) {
            newUsername = Usernames.adjectives.randomItem() + Usernames.nouns.randomItem()
        }
        
        // Insert to currentUsernames
        User.currentUsernames.insert(newUsername)
        
        return newUsername
    }
    
}

// MARK: Helper functions
//extension User {
//    func stories(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
//}
