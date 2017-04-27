import Vapor
import Fluent
import Foundation

final class Post: Model {
    
    // MARK: - Instance Variables
    var id: Node?
    var exists: Bool = false
    
    var mediaAssetURL: String
    var mediaThumbURL: String
    var isVideo: Bool
    var createdAt: Date
    var updatedAt: Date
    var userId: Node?
    
    // MARK: - Inits
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
        mediaAssetURL = try node.extract("media_asset_url")
        mediaThumbURL = try node.extract("media_thumb_url")
        isVideo = try node.extract("is_video")
        createdAt = Date()
        updatedAt = Date()
        userId = try node.extract("user_id")
    }

}

// MARK: - Node Representable
extension Post: NodeRepresentable {
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id?.makeNode(),
            "media_asset_url": mediaAssetURL.makeNode(),
            "media_thumb_url": mediaThumbURL.makeNode(),
            "is_video": isVideo.makeNode(),
            "created_at": createdAt.hsfToString().makeNode(),
            "updated_at": updatedAt.hsfToString().makeNode(),
            "user_id": userId
            ])
    }
}

// MARK: - Database
extension Post {
    
    static func prepare(_ database: Database) throws {
        try database.create("posts") { posts in
            posts.id()
            posts.string("media_asset_url")
            posts.string("media_thumb_url")
            posts.bool("is_video")
            posts.string("created_at")
            posts.string("updated_at")
            posts.parent(User.self, optional: false)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("posts")
    }
    
}

// MARK: Helper functions
extension Post {
    func user() throws -> User? {
        return try parent(userId, nil, User.self).get()
    }
}
