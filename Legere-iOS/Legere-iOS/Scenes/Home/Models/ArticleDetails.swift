//
//  ArticleDetails.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/5/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation

final class ArticleDetails: Codable {
    var article: Article?
    var isLikedByCurrentUser: Bool?
    
    init(article: Article) {
        self.article = article
    }
}
