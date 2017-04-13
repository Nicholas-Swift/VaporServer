import Vapor
import Fluent
import Foundation

final class Post: Model {
    
    // MARK: - Instance Vars
    var id: Node?
    
    var mediaAssetURL: String
    var mediaThumbURL: String
    var isVideo: Bool
    var belongsTo: User
    
    var createdAt: Date
    var updatedAt: Date
    
    // MARK: - Inits
    init(mediaAssetURL: String, mediaThumbURL: String, isVideo: Bool, user: User) {
        self.id = UUID().uuidString.makeNode()
        
        self.mediaAssetURL = mediaAssetURL
        self.mediaThumbURL = mediaThumbURL
        self.isVideo = isVideo
        self.belongsTo = user
        
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        
        mediaAssetURL = try node.extract("mediaAssetURL")
        mediaThumbURL = try node.extract("mediaThumbURL")
        isVideo = try node.extract("isVideo")
        belongsTo = try node.extract("belongsTo")
        
        createdAt = try DateFormatter().date(from: node.extract("createdAt"))!
        updatedAt = try DateFormatter().date(from: node.extract("updatedAt"))!
    }
    
    // MARK: - Node
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            
            "mediaAssetURL": mediaAssetURL,
            "mediaThumbURL": mediaThumbURL,
            "isVideo": isVideo,
            "belongsTo": belongsTo,
            
            "createdAt": DateFormatter().string(from: createdAt),
            "updatedAt": DateFormatter().string(from: updatedAt)])
    }
    
}

// MARK: - Database Preparation
extension Post: Preparation {
    
    static func prepare(_ database: Database) throws {
        // prepare stuff here
    }
    
    static func revert(_ database: Database) throws {
        // revert stuff here
    }
    
}
