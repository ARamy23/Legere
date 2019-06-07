//
//  User.swift
//  App
//
//  Created by Ahmed Ramy on 3/17/19.
//

import Vapor
import Foundation
import FluentPostgreSQL
import Authentication

final class User: Codable {
    /// this is same as the id we used in the article, just more unique
    var id: UUID?
    var name: String
    var username: String
    var password: String
    var profilePicture: String?
    
    init(name: String, username: String, password: String, profilePicture: String? = nil) {
        self.name = name
        self.username = username
        self.password = password
        self.profilePicture = profilePicture
    }
    
    final class Public: Codable {
        var id: UUID?
        var name: String
        var username: String
        var profilePicture: String?
        
        init(id: UUID?, name: String, username: String, profilePicture: String? = nil) {
            self.id = id
            self.name = name
            self.username = username
            self.profilePicture = profilePicture
        }
    }
}


extension User: BasicAuthenticatable {
    static let usernameKey: UsernameKey = \User.username
    static let passwordKey: PasswordKey = \User.password
}
extension User: PostgreSQLUUIDModel {}
extension User: Content {}
extension User.Public: Content {}

extension User {
    func convertToPublic() -> User.Public {
        return User.Public(id: id, name: name, username: username, profilePicture: profilePicture)
    }
}

extension Future where T: User {
    func convertToPublic() -> Future<User.Public> {
        return self.map(to: User.Public.self, { user in
            return user.convertToPublic()
        })
    }
}

// extending the Article to Migration here means that
// this model can be used by the database
// and prepares the database to use this model before your application runs.
extension User: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.username)
        }
    }
}

extension User: Parameter {}

extension User {
    var articles: Children<User, Article> {
        return children(\.userID)
    }
}

extension User: TokenAuthenticatable {
    typealias TokenType = Token
}

extension User {
    var likes: Siblings<User, Article, LikesPivot> {
        return siblings()
    }
}

struct AdminUser: Migration {
    typealias Database = PostgreSQLDatabase
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        let password = try? BCrypt.hash("password")
        guard let hashedPassword = password else {
            fatalError("Failed to create admin user")
        }
        let user = User(name: "Admin", username: "admin", password: hashedPassword)
        return user.save(on: connection).transform(to: ())
    }
    
    static func revert(on connection: PostgreSQLConnection) -> Future<Void> {
        return .done(on: connection)
    }
}
