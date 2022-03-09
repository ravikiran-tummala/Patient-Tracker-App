//
//  File.swift
//  
//
//  Created by Ravi Kiran Tummala on 09/03/22.
//

import Vapor
import Fluent

struct UsersController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
      
    let userRoutes = routes.grouped("api", "users")
    userRoutes.get(use: getAllHandler)
    userRoutes.post(use: createHandler)
  }
  
  func getAllHandler(_ req: Request) -> EventLoopFuture<[User]> {
    User.query(on: req.db).all()
  }
  
  func createHandler(_ req: Request) throws -> EventLoopFuture<User> {
    let user = try req.content.decode(User.self)
    return user.save(on: req.db).map { user }
  }

}

