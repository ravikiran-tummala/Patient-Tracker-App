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
      
    let userRoutes = routes.grouped("api","users")
      
    userRoutes.get(use: getAllHandler)
    userRoutes.get(":userID",use:getHandler)
    userRoutes.post(use: createHandler)
    userRoutes.put(":userID",use:updateHandler)
    userRoutes.delete(":userID", use: deleteHandler)
    userRoutes.get("search",use:searchHandler)
    userRoutes.get("sorted",use:sortHandler)
  }
  
  func getAllHandler(_ req: Request) -> EventLoopFuture<[User]> {
    User.query(on: req.db).all()
  }
    
  func getHandler(_ req: Request) -> EventLoopFuture<User>{
    User.find(req.parameters.get("userID"), on: req.db)
          .unwrap(or: Abort(.notFound))
  }
  
  func createHandler(_ req: Request) throws -> EventLoopFuture<User> {
    let user = try req.content.decode(User.self)
    return user.save(on: req.db).map { user }
  }
    
  func updateHandler(_ req:Request) throws -> EventLoopFuture<User>{
    let updatedUser = try req.content.decode(User.self)
      return User.find(req.parameters.get("userID"), on: req.db)
          .unwrap(or: Abort(.notFound)).flatMap{ user in
              user.username = updatedUser.username
              user.name = updatedUser.name
              user.age = updatedUser.age
              user.sex = updatedUser.sex
              return user.save(on: req.db).map{
                  user
              }
          }
  }
    
  func deleteHandler(_ req:Request) -> EventLoopFuture<HTTPStatus>{
      User.find(req.parameters.get("userID"), on: req.db)
          .unwrap(or: Abort(.notFound))
          .flatMap{ user in
              user.delete(on: req.db)
                  .transform(to: .noContent)
          }
  }
    
    func searchHandler(_ req:Request) throws -> EventLoopFuture<[User]>{
        guard let searchUsername = req.query[String.self,at:"username"] else{
            throw Abort(.badRequest)
        }
        return User.query(on: req.db)
            .filter(\.$username == searchUsername)
            .all()
    }
    
    func sortHandler(_ req:Request) -> EventLoopFuture<[User]>{
        return User.query(on: req.db)
            .sort(\.$username,.ascending)
            .all()
    }

}

