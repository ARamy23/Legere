//
//  IsValidPassowrd.swift
//
//  Created by Ahmed Meguid on 12/5/18.
//  Copyright © 2018 Ahmed Meguid. All rights reserved.
//

import Foundation

final class IsValidPassword: BaseValidator {
    
    var value: String?
    var confirmValue: String?
    
    init(value: String?, confirmValue: String? = nil) {
        self.value = value
        self.confirmValue = confirmValue
    }
    
    func orThrow() throws {
        
        let error = NotValidPasswordError()
        
        if let value = value {
            if value.count >= 6 {
                return
            }
            
            if value.count < 6 {
                error.reason = .tooShort
            } else if let confirmValue = confirmValue, confirmValue != value {
                error.reason = .notEqualToConfirmValue
            }
        }
        
        throw error
    }
}
