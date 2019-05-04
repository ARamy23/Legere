//
//  IsValidName.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation

final class IsValidName: BaseValidator {
    
    var value: String?
    
    init(value: String?) {
        self.value = value
    }
    
    func orThrow() throws {
        
        let error = NotValidNameError()
        
        if let value = value {
            if isValid(name: value) {
                return
            }
            
            if value.isAlphaNumeric {
                error.reason = .containsCharactersWhichAreNotAlphabetics
            } else if value.containEmoji {
                error.reason = .containsEmojis
            }
        }
        throw error
    }
    
    func isValid(name: String) -> Bool {
        return name.isAlphabetic && !name.isAlphaNumeric && !name.containEmoji
    }
}
