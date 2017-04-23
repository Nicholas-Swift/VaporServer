//
//  jwtauth.swift
//  VaporServer
//
//  Created by Alex Aaron Peña on 4/15/17.
//
//


import Vapor
import HTTP
import Turnstile
import Auth
import JWT

class BearerAuthMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        // Authorization: Bearer Token
        if let bearer = request.auth.header?.bearer {
            try request.auth.login(bearer)
        }
        
        return try next.respond(to: request)
    }
}
