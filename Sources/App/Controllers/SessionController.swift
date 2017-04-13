////
////  SessionController.swift
////  VaporServer
////
////  Created by Nicholas Swift on 4/9/17.
////
////
//
//import Vapor
//import HTTP
//
//class SessionController: ResourceRepresentable {
//    
//    // Create
//    func create(request: Request) throws -> ResponseRepresentable {
//        var post = try request.post()
//        try post.save()
//        return post
//    }
//    
//}
//
//// MARK: - Make Resource
//extension SessionController {
//    
//    func makeResource() -> Resource<Post> {
//        return Resource(
//            store: create
//        )
//    }
//    
//}
