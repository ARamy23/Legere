//
//  LikesPivot.swift
//  App
//
//  Created by Ahmed Ramy on 6/7/19.
//

import FluentPostgreSQL

final class LikesPivot: PostgreSQLUUIDPivot {
    var id: UUID?
    var articleID: Article.ID
    var userID: User.ID
    
    typealias Left = Article
    typealias Right = User
    
    static let leftIDKey: LeftIDKey = \.articleID
    static let rightIDKey: RightIDKey = \.userID
    
    init(_ article: Article, _ user: User) throws {
        self.articleID = try article.requireID()
        self.userID = try user.requireID()
    }
}

extension LikesPivot: ModifiablePivot { }

extension LikesPivot: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.articleID, to: \Article.id, onDelete: .cascade)
            builder.reference(from: \.userID, to: \User.id, onDelete: .cascade)
        }
    }
}
