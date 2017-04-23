////
////  StoryController.swift
////  VaporServer
////
////  Created by Nicholas Swift on 4/9/17.
////
////
//
//import Foundation
//import Vapor
//import HTTP
//
//class StoryController: ResourceRepresentable {
//    
//    func index(request: Request) throws -> ResponseRepresentable {
//        
//        let users = User.query().fil
//        
//        // let users = users in database where lastPostedAt is less than 2 days ago.
//        // users.posts.filter{ make sure all posts are less than 2 days ago }
//        
//        // guard let myUser = get user from auth jwtToken else { return users }
//        // users.remove(myUser)
//        // return users
//        
//        return "wow"
//    }
//    
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
//}
//
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
