//
//  File.swift
//  
//
//  Created by Ravi Kiran Tummala on 09/03/22.
//

import Vapor
import Fluent

final class User: Model,Content {
  static let schema = "users"
  
  @ID
  var id: UUID?
  
  @Field(key: "name")
  var name: String
  
  @Field(key: "username")
  var username: String
    
  @Field(key: "sex")
  var sex: String
    
  @Field(key: "age")
  var age: Int
  
  init() {}
  
  init(id: UUID? = nil,
       name: String,
       username: String,
       sex:String,
       age:Int) {
    self.id = id
    self.name = name
    self.username = username
    self.sex = sex
    self.age = age
  }
}
