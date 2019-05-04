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
        
    }
}
