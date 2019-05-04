//
//  NotValidEmail.swift
//  EvenTask
//
//  Created by Ahmed Meguid on 1/23/19.
//  Copyright © 2019 Ahmed Meguid. All rights reserved.
//

import Foundation

enum NotValidUsernameReason {
    case containsSpaces
}

final class NotValidUsernameError: Error, LocalizedError {
    
    var reason: NotValidUsernameReason?
    
    public var errorDescription: String? {
        switch reason {
        case .containsSpaces?:
            return "Username can't contain spaces"
        default:
            return "Username is not valid"
        }
    }
}
