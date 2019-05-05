//
//  ArticlesService.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Moya

enum ArticlesService {
    case allArticles
    case articleDetails(id: Int)
    case didRead(articleId: Int)
}

extension ArticlesService: BaseTargetType {
    var path: String {
        switch self {
        case .allArticles:
            return "/api/articles"
        case .articleDetails(id: let id):
            return "/api/articles/\(id)"
        case .didRead(articleId: let id):
            return "/api/articles/\(id)"
        }
    }
    
    var method: Method {
        switch self {
        case .allArticles:
            return .get
        case .articleDetails:
            return .get
        case .didRead:
            return .put
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .allArticles:
            return .requestPlain
        case .articleDetails:
            return .requestPlain
        case .didRead:
            return .requestPlain
        }
    }
}

struct ArticlesServiceManager {
    let provider = MoyaProvider<ArticlesService>(plugins: [NetworkLoggerPlugin(verbose: true)])
}
