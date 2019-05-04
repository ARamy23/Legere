//
//  LoginInteractor.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import RxSwift

final class LoginInteractor: BaseInteractor {
    var username: String?
    var password: String?
    
    init(username: String?, password: String?, base: BaseInteractor) {
        super.init(cache: base.cache)
        self.username = username
        self.password = password
    }
    
    override func validate() throws {
        try NotEmpty(value: username, key: .usernameField)
        try NotEmpty(value: password, key: .passwordField)
        try IsValidEmail(value: <#T##String?#>)
    }
}
