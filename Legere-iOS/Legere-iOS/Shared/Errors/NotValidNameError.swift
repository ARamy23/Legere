//
//  NotValidNameError.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation

enum NotValidNameReason {
    case containsCharactersWhichAreNotAlphabetics
    case containsEmojis
}

final class NotValidNameError: Error, LocalizedError {
    
    var reason: NotValidNameReason?
    
    public var errorDescription: String? {
        switch reason {
        case .containsCharactersWhichAreNotAlphabetics?:
            return "Name can only contain characters and spaces"
        case .containsEmojis?:
            return "Name can't contain emojis! 😡"
        default:
            return "Name is not valid"
        }
    }
}
