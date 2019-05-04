//
//  Models+Testable.swift
//  AppTests
//
//  Created by Ahmed Ramy on 3/14/19.
//

@testable import App
import FluentPostgreSQL
import Crypto

extension User {
    static func create(name: String = "Luke",
                       username: String? = nil,
                       on connection: PostgreSQLConnection) throws -> User {
        let createdUsername: String
        
        if let suppliedUsername = username {
            createdUsername = suppliedUsername
        } else {
            createdUsername = UUID().uuidString
        }
        
        let password = try BCrypt.hash("password")
        let user = User(name: name, username: createdUsername, password: password)
        return try user.save(on: connection).wait()
    }
}

extension Article {
    static func create(
        title: String = "Today I Read About Vapor...",
        details: String = "It was such a cool experience!",
        user: User? = nil,
        on connection: PostgreSQLConnection
        ) throws -> Article {
        
        var author = user
        
        if user == nil {
            author = try User.create(on: connection)
        }
        
        let article = Article(
            title: title,
            details: details,
            userID: author!.id!,
            reads: 0
            )
        return try article.save(on: connection).wait()
    }
}

extension App.Category {
    static func create(
        name: String = "Random",
        on connection: PostgreSQLConnection
        ) throws -> App.Category {
        let category = App.Category(name: name)
        return try category.save(on: connection).wait()
    }
}
