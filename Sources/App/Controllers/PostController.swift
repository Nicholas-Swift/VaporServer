//
//  PostController.swift
//  VaporServer
//
//  Created by Nicholas Swift on 4/9/17.
//
//

import Vapor
import HTTP

final class PostController: ResourceRepresentable {
    
    // Index
    func index(request: Request) throws -> ResponseRepresentable {
        return try Post.all().makeNode().converted(to: JSON.self)
    }

    // Create
    func create(request: Request) throws -> ResponseRepresentable {
        var post = try request.post()
        // let user = GET_USER_FROM_REQUEST_JWT_TOKEN
        
        // post.belongsTo = user???
        // user.posts.append(post) ??
        
        try post.save()
        // If post successfully saved do the rest
            // // Update user
            // user.lastPostedAt = Date()
            // update user in database
        return post
    }

    // Show
    func show(request: Request, post: Post) throws -> ResponseRepresentable {
        return post
    }
    
    // Delete
    func delete(request: Request, post: Post) throws -> ResponseRepresentable {
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
