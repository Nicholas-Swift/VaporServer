//
//  MainController.swift
//  VaporServer
//
//  Created by Nicholas Swift on 4/9/17.
//
//

import Vapor
import HTTP

class MainController: ResourceRepresentable {
    
    // GET
    func index(request: Request) throws -> ResponseRepresentable {
        return JSON(["data": "index"])
    }
    
    // POST
    func create(request: Request) throws -> ResponseRepresentable {
        return JSON(["data": "create"])
    }
    
    // GET IF /main/id
    func show(request: Request, post: Post) throws -> ResponseRepresentable {
        return JSON(["data": "show"])
    }
    
    // DELETE if /main/id
    func delete(request: Request, post: Post) throws -> ResponseRepresentable {
        return JSON(["data": "delete"])
    }
    
    // DELETE
    func clear(request: Request) throws -> ResponseRepresentable {
        return JSON(["data": "clear"])
    }
    
    func update(request: Request, post: Post) throws -> ResponseRepresentable {
        return JSON(["data": "update"])
    }
    
    func replace(request: Request, post: Post) throws -> ResponseRepresentable {
        return JSON(["data": "replace"])
    }
    
    // MARK: - Make Resource
    func makeResource() -> Resource<Post> {
        return Resource(
            index: index,
            store: create,
            show: show,
            replace: replace,
            modify: update,
            destroy: delete,
            clear: clear
        )
    }
    
}
