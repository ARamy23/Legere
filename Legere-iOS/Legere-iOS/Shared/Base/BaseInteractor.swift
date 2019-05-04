//
//  BaseInteractor.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import Promises

class BaseInteractor {
    var cache: CacheProtocol
    var network: NetworkProtocol
    
    init(network: NetworkProtocol, cache: CacheProtocol) {
        self.cache = cache
        self.network = network
    }
    
    func execute<T: Codable>(_ model: T.Type) -> Promise<T> {
        do {
            extract()
            try validate()
            return process(model)
        } catch let error {
            return Promise<T>.init(error)
        }
    }
    
    func validate() throws {}
    func extract() {}
    
    func process<T: Codable>(_ model: T.Type) -> Promise<T> {
        return Promise<T>.init(NSError(domain: "Error", code: 100, userInfo: nil))
    }
}
