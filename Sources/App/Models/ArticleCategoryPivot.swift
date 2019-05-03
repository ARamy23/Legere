//
//  ArticleCategoryPivot.swift
//  App
//
//  Created by Ahmed Ramy on 3/18/19.
//

import FluentPostgreSQL
import Foundation

final class ArticleCategoryPivot: PostgreSQLUUIDPivot {
    
    var id: UUID?
    var articleID: Article.ID
    var categoryID: Category.ID
    
    typealias Left = Article
    typealias Right = Category
    static let leftIDKey: LeftIDKey = \.articleID
    static let rightIDKey: RightIDKey = \.categoryID
    
    init(_ article: Article, _ category: Category) throws {
        self.articleID = try article.requireID()
        self.categoryID = try category.requireID()
    }
}

extension ArticleCategoryPivot: ModifiablePivot {}

extension ArticleCategoryPivot: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.articleID, to: \Article.id, onDelete: .cascade)
            builder.reference(from: \.categoryID, to: \Category.id, onDelete: .cascade)
        }
    }
}
