//
//  NotValidPasswordError.swift
//  EvenTask
//
//  Created by Ahmed Meguid on 1/23/19.
//  Copyright © 2019 Ahmed Meguid. All rights reserved.
//

import Foundation

enum NotValidPasswordReason {
    case tooShort
    case notEqualToConfirmValue
}

class NotValidPasswordError: Error, LocalizedError {
    
    var reason: NotValidPasswordReason?
    
    public var errorDescription: String? {
        switch reason {
        case .tooShort?:
            return "Please enter a valid password with at least 6 characters"
        case .notEqualToConfirmValue?:
            return "Passwords do not match"
        default:
            return "Passwords are not valid"
        }
    }
}
