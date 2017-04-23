//
//  PostController.swift
//  VaporServer
//
//  Created by Nicholas Swift on 4/9/17.
//
//

import Vapor
import HTTP
import Foundation

final class PostController: ResourceRepresentable {
    
    // Index
    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(Post.all().makeNode())
    }

    // Show
    func show(request: Request, post: Post) throws -> ResponseRepresentable {
        return try JSON(post.makeNode())
    }
    
    // Create - AUTH
    func create(request: Request) throws -> ResponseRepresentable {
        
        // Get post and user from auth
        var post = try request.post()
        var user = try request.user() // let user = GET_USER_FROM_REQUEST_JWT_TOKEN
        
        // post.userId = user.id // post.belongsTo = user??? // user.posts.append(post) ??
        
        // Try saving and updating
        try post.save()
        user.lastPostedAt = Date()
        try user.save()
        // If post successfully saved do the rest
            // // Update user
            // user.lastPostedAt = Date()
            // update user in database
        
        return try JSON(post.makeNode())
    }
    
    // Delete - AUTH
    func delete(request: Request, post: Post) throws -> ResponseRepresentable {
        
        // Get user from auth
        let user = try request.user()
        
        // Not matching same id
//        if post.userId != user.id {
//            throw Abort.custom(status: .unauthorized, message: "You are not authorized to delete this")
//        }
        
        try post.delete()
        return JSON([:])
    }
}

// MARK: - Make Resource
extension PostController {
    
    func makeResource() -> Resource<Post> {
        return Resource(
            index: index,
            store: create,
            show: show,
            destroy: delete
        )
    }
    
}

// MARK: - Post Request Extension
extension Request {
    func post() throws -> Post {
        guard let json = json else { throw Abort.badRequest }
        return try Post(node: json)
    }
}
