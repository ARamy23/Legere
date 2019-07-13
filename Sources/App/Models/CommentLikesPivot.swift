//
//  CommentLikesPivot.swift
//  App
//
//  Created by Ahmed Ramy on 7/12/19.
//

import FluentPostgreSQL

final class CommentLikesPivot: PostgreSQLUUIDPivot {
    
    var id: UUID?
    var commentID: Comment.ID
    var userID: User.ID
    
    typealias Left = Comment
    typealias Right = User
    
    static let leftIDKey: LeftIDKey = \.commentID
    static let rightIDKey: RightIDKey = \.userID
    
    init(_ comment: Comment, _ user: User) throws {
        self.commentID = try comment.requireID()
        self.userID = try user.requireID()
    }
}

extension CommentLikesPivot: ModifiablePivot { }

extension CommentLikesPivot: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.commentID, to: \Comment.id, onDelete: .cascade)
            builder.reference(from: \.userID, to: \User.id, onDelete: .cascade)
        }
    }
}
