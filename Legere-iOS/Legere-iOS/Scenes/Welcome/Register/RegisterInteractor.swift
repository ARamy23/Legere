//
//  RegisterInteractor.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import Promises

final class RegisterInteractor: BaseInteractor {
    var name: String?
    var username: String?
    var password: String?
    var confirmPassword: String?
    
    init(name: String?, username: String?, password: String?, confirmPassword: String?, base: BaseInteractor) {
        super.init(network: base.network, cache: base.cache)
        self.name = name
        self.username = username
        self.password = password
        self.confirmPassword = confirmPassword
    }
    
    override func validate() throws {
        try NotEmpty(value: name, key: .nameField).orThrow()
        try NotEmpty(value: username, key: .usernameField).orThrow()
        try NotEmpty(value: password, key: .passwordField).orThrow()
        try NotEmpty(value: confirmPassword, key: .confirmPasswordField).orThrow()
        try IsValidName(value: name).orThrow()
        try IsValidUsername(value: username).orThrow()
        try IsValidPassword(value: password, confirmValue: confirmPassword).orThrow()
    }
    
    override func process<T>(_ model: T.Type) -> Promise<T> where T : Decodable, T : Encodable {
        return network.callModel(model: model, api: AuthenticationService.register(name: name ?? "", username: username ?? "", password: password ?? ""))
    }
}
