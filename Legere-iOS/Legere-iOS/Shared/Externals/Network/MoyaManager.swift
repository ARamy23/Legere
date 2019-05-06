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
    func callModel<T, U>(model: T.Type, api: U) -> Promise<T> where T : Decodable, T : Encodable, U : BaseTargetType {
        return Promise<T> { fullfil, reject in
            let provider = MoyaProvider<U>(plugins: [NetworkLoggerPlugin(verbose: true)])
            provider.request(api) { (result) in
                switch result {
                case .success(let response):
                    do {
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
