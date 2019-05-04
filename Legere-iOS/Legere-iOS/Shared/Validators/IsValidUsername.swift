//
//  IsValidEmail.swift
//
//  Created by Ahmed Meguid on 12/5/18.
//  Copyright © 2018 Ahmed Meguid. All rights reserved.
//

import Foundation
import SwifterSwift

final class IsValidUsername: BaseValidator {
    
    var value: String?
    
    init(value: String?) {
        self.value = value
    }
    
    func orThrow() throws {
        
        let error = NotValidUsernameError()
        
        if let value = value {
            if isValid(username: value) {
                return
            }
            
            if value.contains(" ") {
                error.reason = .containsSpaces
            }
        }
        throw error
    }
    
    func isValid(username: String) -> Bool {
        return (username.isAlphabetic || username.isAlphaNumeric) && !username.contains(" ")
    }
}
