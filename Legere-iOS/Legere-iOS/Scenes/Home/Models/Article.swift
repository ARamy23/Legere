//
//  Article.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation

typealias Articles = [Article]

struct Article: Codable {
    /// ID to article
    /// can be later used in fetching the article through URL
    /// example: to fetch first article there ever was
    /// use this ~> localhost:8080/articles/1
    var id: Int?
    
    /// Title for the article
    var title: String?
    
    /// Article details you have about this article
    var details: String?
    
    /// we use this as a link between the article and the user
    /// we call this kind of link one to many where
    /// a user (author) can have many articles
    /// but an article can only have one author
    var userID: String?
    
    /// Number of reads for this article
    var reads: Int
    
    var likedBy: [String] {
        didSet {
            numberOfLikes = likedBy.count
        }
    }
    
    var numberOfLikes: Int
    
    init(title: String, details: String, userID: String, reads: Int = 0, likedBy: [String] = []) {
        self.title = title
        self.details = details
        self.userID = userID
        self.reads = reads
        self.likedBy = likedBy
        self.numberOfLikes = likedBy.count
    }
}

extension Article: Equatable {
    static func ==(lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id && lhs.reads == rhs.reads && lhs.numberOfLikes == rhs.numberOfLikes
    }
}
