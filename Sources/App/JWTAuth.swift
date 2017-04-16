//
//  JWTAuth.swift
//  VaporServer
//
//  Created by Alex Peña on 4/15/17.
//
//

import Vapor
import VaporJWT

final class JWTAuthMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        if let token = request.auth.header?.bearer?.string {
            request.user = try validateAndGetUser(token: token)
        }
        
        let response = try next.respond(to: request)
        
        return response
    }
    
    public func validateAndGetUser(token: String) throws -> User{
        
        let jwt =  try JWT(token: token)
        
        let isValid = try jwt.verifySignatureWith(HS256(key: "secret"))
        
        if(!isValid){
            throw Abort.custom(status: .forbidden, message: "Invalid access token")
        }
        
        guard let userId = jwt.payload["id"]?.string else { throw Abort.custom(status: .forbidden, message: "Invalid access token") }
        
        guard let user = try User.query().filter("google_id", userId).first() else {
            throw Abort.badRequest
        }
        
        return user
        
    }
}
