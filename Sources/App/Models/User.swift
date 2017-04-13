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
    
    // MARK: - Instance Vars
    var id: Node?
    
    var passwordHash: String
    var username: String
    var password: String
    var lastPostedAt: Date
    var posts: [Post]
    
    var createdAt: Date
    var updatedAt: Date
    
    // MARK: - Inits
    init(password: String) {
        self.id = UUID().uuidString.makeNode()
        
        // Init my shit here
        
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
            "lastPostedAt": DateFormatter().string(from: lastPostedAt),
//            "posts": posts,
            
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
