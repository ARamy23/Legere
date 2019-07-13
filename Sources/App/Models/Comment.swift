//
//  Comment.swift
//  App
//
//  Created by Ahmed Ramy on 7/12/19.
//

import Vapor
import FluentPostgreSQL

final class Comment: Codable {
    var id: Int?
    var details: String
    var userID: User.ID
    var articleID: Article.ID
    var likes: Int
    
    init(details: String, userID: User.ID, articleID: Article.ID, likes: Int = 0) {
        self.details = details
        self.userID = userID
        self.articleID = articleID
        self.likes = likes
    }
    
    struct CommentDetails: Content {
        let user: User.Public
        let comment: Comment
    }
}

extension Comment: PostgreSQLModel {}

extension Comment: Content {}

extension Comment: Parameter {}

extension Comment: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.userID, to: \User.id)
        }
    }
}

extension Comment {
    var article: Parent<Comment, Article> {
        return parent(\.articleID)
    }
}

extension Comment {
    var author: Parent<Comment, User> {
        return parent(\.userID)
    }
}

extension Comment {
    var likers: Siblings<Comment, User, CommentLikesPivot> {
        return siblings()
    }
}
