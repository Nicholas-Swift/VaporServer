//
//  User.swift
//  VaporServer
//
//  Created by Nicholas Swift on 4/9/17.
//
//

import Vapor
import Foundation

final class User: Model {
    
    static var currentUsernames: Set<String> = Set()
    var id: Node?
    var exists: Bool = false
    
    var username: String
    var password: String
    var lastPostedAt: Date?
    
    var createdAt: Date
    var updatedAt: Date
    
    init(password: String) {
        self.username = User.generateUsername()
        self.password = password
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        
        username = try node.extract("username")
        password = try node.extract("password")
        lastPostedAt = try DateFormatter().date(from: node.extract("lastPostedAt"))
        
        createdAt = try DateFormatter().date(from: node.extract("createdAt"))!
        updatedAt = try DateFormatter().date(from: node.extract("updatedAt"))!
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "username": username,
            "password": password,
            "lastPostedAt": lastPostedAt == nil ? nil : DateFormatter().string(from: lastPostedAt!),
            "createdAt": DateFormatter().string(from: createdAt),
            "updatedAt": DateFormatter().string(from: updatedAt)
        ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("users") { users in
            users.id()
            users.string("username")
            users.string("password")
            users.string("lastPostedAt")
            users.string("createdAt")
            users.string("updatedAt")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("posts")
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
