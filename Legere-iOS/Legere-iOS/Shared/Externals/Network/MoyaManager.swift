//
//  MoyaManager.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import Moya
import Promises

class MoyaManager: NetworkProtocol {
    static var ongoingRequests = [Cancellable]()
    
    func callModel<T, U>(model: T.Type, api: U) -> Promise<T> where T : Decodable, T : Encodable, U : BaseTargetType {
        return Promise<T> { fullfil, reject in
            let provider = MoyaProvider<U>()
            provider.request(api) { (result) in
                switch result {
                case .success(let response):
                    do {
                        if let error = try? response.map(NetworkError.self), error.error == true {
                            reject(error)
                        }
                        let model = try response.map(T.self)
                        fullfil(model)
                    } catch let error {
                        reject(error)
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
}

struct NetworkError: Error, LocalizedError, Codable {
    let error: Bool?
    let reason: String?
    
    var errorDescription: String? {
        return reason ?? "Something went wrong."
    }
}
