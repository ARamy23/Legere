//
//  EmptyValueError.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation

class EmptyValueError: Error, LocalizedError {
    var key: String
    
    init(key: String) {
        self.key = key
    }
    
    public var errorDescription: String? {
        return "Please fill in the \(key) value"
    }
}
