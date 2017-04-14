//
//  User.swift
//  VaporServer
//
//  Created by Nicholas Swift on 4/9/17.
//
//

import Vapor
import Fluent
import Foundation

final class User: Model {
    
    // MARK: - Class Vars
    static var currentUsernames: Set<String> = Set() // on init, set of all usernames in database
    
    // MARK: - Instance Vars
    var id: Node?
    
    var passwordHash: String
    var username: String
    var password: String
    var lastPostedAt: Date?
    var posts: [Post]
    
    var createdAt: Date
    var updatedAt: Date
    
    // MARK: - Inits
    init(password: String) {
        self.id = UUID().uuidString.makeNode()
        
        self.passwordHash = "?"
        self.username = self.generateUsername()
        self.password = password
        self.posts = []
        self.lastPostedAt = nil
        
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        
        passwordHash = try node.extract("passwordHash")
        username = try node.extract("username")
        password = try node.extract("password")
        posts = try node.extract("posts")
        lastPostedAt = try DateFormatter().date(from: node.extract("lastPostedAt"))!
        
        createdAt = try DateFormatter().date(from: node.extract("createdAt"))!
        updatedAt = try DateFormatter().date(from: node.extract("updatedAt"))!
    }
    
    // MARK: - Node
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            
            "passwordHash": passwordHash,
            "username": username,
            "password": password,
            "lastPostedAt": lastPostedAt == nil ? nil : DateFormatter().string(from: lastPostedAt!),
            "posts": try posts.makeNode(),
            
            "createdAt": DateFormatter().string(from: createdAt),
            "updatedAt": DateFormatter().string(from: updatedAt)])
    }
}

// MARK: - Database Preparations
extension User: Preparation {
    static func prepare(_ database: Database) throws {
        // prepare
    }
    
    static func revert(_ database: Database) throws {
        // revert
    }
}

// MARK: - Username Creation
extension User {
    
    fileprivate func generateUsername() -> String {
        
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
