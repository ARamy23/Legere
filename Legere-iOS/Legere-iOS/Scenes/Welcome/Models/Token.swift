//
//  Token.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/5/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation

struct Token: Codable {
    let id: String?
    let token: String?
    let userID: String?
    
    init(id: String?, token: String?, userID: String?) {
        self.id = id
        self.token = token
        self.userID = userID
    }
}
