import Vapor
import Fluent
import Foundation

final class Post: Model {
    var id: Node?
    var exists: Bool = false
    
    var mediaAssetURL: String
    var mediaThumbURL: String
    var isVideo: Bool
    
    var createdAt: Date
    var updatedAt: Date
    
    var userId: Node?
    
    init(mediaAssetURL: String, mediaThumbURL: String, isVideo: Bool, userId: Node? = nil) {
        self.mediaAssetURL = mediaAssetURL
        self.mediaThumbURL = mediaThumbURL
        self.isVideo = isVideo
        
        self.createdAt = Date()
        self.updatedAt = Date()
        
        self.userId = userId
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        
        mediaAssetURL = try node.extract("mediaAssetURL")
        mediaThumbURL = try node.extract("mediaThumbURL")
        isVideo = try node.extract("isVideo")
        
        createdAt = try DateFormatter().date(from: node.extract("createdAt"))!
        updatedAt = try DateFormatter().date(from: node.extract("updatedAt"))!
        
        userId = try node.extract("user_Id")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            
            "mediaAssetURL": mediaAssetURL,
            "mediaThumbURL": mediaThumbURL,
            "isVideo": isVideo,
            
            "createdAt": DateFormatter().string(from: createdAt),
            "updatedAt": DateFormatter().string(from: updatedAt),
            
            "userId": userId
        ])
    }
}

// MARK: - Database
extension Post {
    
    static func prepare(_ database: Database) throws {
        try database.create("posts") { users in
            users.id()
            users.string("mediaAssetURL")
            users.string("mediaThumbURL")
            users.bool("isVideo")
            users.string("createdAt")
            users.string("updatedAt")
            
            users.parent(User.self, optional: false)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("posts")
    }
    
}
