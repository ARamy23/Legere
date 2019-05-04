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
}

extension ArticlesService: BaseTargetType {
    var path: String {
        switch self {
        case .allArticles:
            return "/api/articles"
        }
    }
    
    var method: Method {
        switch self {
        case .allArticles:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .allArticles:
            return .requestPlain
        }
    }
}

struct ArticlesServiceManager {
    let provider = MoyaProvider<ArticlesService>(plugins: [NetworkLoggerPlugin(verbose: true)])
}
