//
//  Authentication.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Moya

enum AuthenticationService {
    case login(username: String, password: String)
    case register(name: String, username: String, password: String)
}

extension AuthenticationService: BaseTargetType {
    var path: String {
        switch self {
        case .login:
            return "/api/users/login"
        case .register:
            return "/api/users"
        }
    }
    
    var method: Method {
        switch self {
        default:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(username: let username, password: let password):
            return .requestParameters(parameters: ["username": username, "password": password], encoding: JSONEncoding.default)
        case .register(name: let name, username: let username, password: let password):
            return .requestParameters(parameters: ["name": name, "username": username, "password": password], encoding: JSONEncoding.default)
        }
    }
    
    
}
