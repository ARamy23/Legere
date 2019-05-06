//
//  RegisterViewModel.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import SimpleTwoWayBinding

final class RegisterViewModel: BaseViewModel {
    var username: Observable<String> = Observable()
    var name: Observable<String> = Observable()
    var password: Observable<String> = Observable()
    var confirmPassword: Observable<String> = Observable()
    
    func register() {
        RegisterInteractor(name: name.value, username: username.value, password: password.value, confirmPassword: confirmPassword.value, base: baseInteractor).execute(User.self).then { [weak self] (user) in
            guard let self = self else { return }
            self.cache.saveObject(user, key: .user)
            (self.router.presentedView as? AuthenticationViewController)?.didTapLogin(UIButton())
            }.catch(handleError)
    }
}
