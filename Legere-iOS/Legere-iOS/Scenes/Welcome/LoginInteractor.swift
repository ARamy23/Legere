//
//  LoginInteractor.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import Promises

final class LoginInteractor: BaseInteractor {
    var username: String?
    var password: String?
    
    init(username: String?, password: String?, base: BaseInteractor) {
        super.init(network: base.network, cache: base.cache)
        self.username = username
        self.password = password
    }
    
    override func validate() throws {
        try NotEmpty(value: username, key: .usernameField).orThrow()
        try NotEmpty(value: password, key: .passwordField).orThrow()
        try IsValidUsername(value: username).orThrow()
        try IsValidPassword(value: password).orThrow()
    }
    
    override func process<T>(_ model: T.Type) -> Promise<T> where T : Decodable, T : Encodable {
        return network.callModel(model: model, api: ArticlesService.allArticles)
    }
}
