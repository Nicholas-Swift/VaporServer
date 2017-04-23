//
//  StoryController.swift
//  VaporServer
//
//  Created by Nicholas Swift on 4/9/17.
//
//

import Foundation
import Vapor
import HTTP

class StoriesController {

    func stories(request: Request) throws -> ResponseRepresentable {
        
        let cutoffDate = Date().addDays(daysToAdd: -2).hsfToString()
        let users = try User.query().filter("last_posted_at", .greaterThan, cutoffDate).all()
        
        let userIds: [String] = users.map{ $0.id!.string! }
        
        if userIds.isEmpty {
            return JSON([:])
        }
        let posts = try Post.query().filter("user_id", .in, userIds).and({ query in
            try query.filter("created_at", .greaterThan, cutoffDate)
        }).all()
        
        return try JSON(node: posts)
    }
    
//    func myStory(request: Request) throws -> ResponseRepresentable {
//        
//        // Get user from auth
//        let user = try request.user()
//        
//        
//        let cutoffDate = Date().addDays(daysToAdd: -2)
//        //let posts = Post.query().filter("userId", .equalTo, user.id).all()
//        let posts = try Post.query().filter("userId", .equals, user.id!)
//        
//        // guard let myUser = get user from auth jwtToken else { return }
//        // myUser.posts.filter{ make sure all posts are less than 2 days ago }
//        // return myUser
//        return "wow"
//    }
//    
//    func usersWithStoriesQuery() {
//        let postsQuery = try recentPostsQuery()
//        
//    }
//    
//    func recentPostsQuery() throws -> [Post] {
//        let cutoffDate = Date().addDays(daysToAdd: -2)
//        let posts = try Post.all().filter { $0.createdAt.isGreaterThanDate(dateToCompare: cutoffDate) }.sorted {
//            $0.0.createdAt.isGreaterThanDate(dateToCompare: $0.1.createdAt) }
//        return posts
//    }
//    
}

//// MARK: - Make Resource
//extension StoryController {
//    
//    func makeResource() -> Resource<User> {
//        return Resource(
//            index: index
////            show: myStory
//        )
//    }
//    
//}
