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
        
    }
}

