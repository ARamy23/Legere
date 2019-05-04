//
//  User.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: UUID?
    var name: String?
    var username: String?
    
    init(id: UUID?, name: String, username: String) {
        self.id = id
        self.name = name
        self.username = username
    }
}
