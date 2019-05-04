//
//  Base Service.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import Moya

protocol BaseTargetType: TargetType { }

extension BaseTargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:8080")!
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}

// MARK: - Helper
extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

