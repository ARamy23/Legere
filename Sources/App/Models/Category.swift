//
//  Category.swift
//  App
//
//  Created by Ahmed Ramy on 3/18/19.
//

import Vapor
import FluentPostgreSQL

final class Category: Codable {
    var id: Int?
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

extension Category: PostgreSQLModel {}
extension Category: Content {}
extension Category: Migration {}
extension Category: Parameter {}

extension Category {
    var articles: Siblings<Category, Article, ArticleCategoryPivot> {
        return siblings()
    }
}
