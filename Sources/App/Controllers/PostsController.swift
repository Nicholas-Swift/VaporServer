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

final class PostsController {
    
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
        // Create and save the post
        var post = try Post(node: request.json)
        try post.save()
        
        // Update the users lastPostedAt
        var user = try User.query().filter("id", (try post.user()?.id)!).first()
        user?.lastPostedAt = Date()
        try user?.save()
        
        return post
    }
    
    // Delete - AUTH
    func delete(request: Request, post: Post) throws -> ResponseRepresentable {
        
        // Get user from auth
//        let user = try request.user()
        
        // Not matching same id
//        if post.userId != user.id {
//            throw Abort.custom(status: .unauthorized, message: "You are not authorized to delete this")
//        }
        
        try post.delete()
        return JSON([:])
    }
}

//// MARK: - Make Resource
//extension PostController {
//    
//    func makeResource() -> Resource<Post> {
//        return Resource(
//            index: index,
//            store: create,
//            show: show,
//            destroy: delete
//        )
//    }
//    
//}
