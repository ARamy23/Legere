//
//  LoginViewModel.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import SimpleTwoWayBinding

final class LoginViewModel: BaseViewModel {
    var username: Observable<String> = Observable()
    var password: Observable<String> = Observable()
    
    func login() {
        LoginInteractor(username: username.value, password: password.value, base: baseInteractor).execute(User.self).then { [weak self] (user) in
            guard let self = self else { return }
            self.cache.saveObject(user, key: .user)
            self.router.present(view: AppStoryboard.Home.initialViewController())
            }.catch { (error) in
                self.router.toastError(title: "Error", message: error.localizedDescription)
        }
    }
}

