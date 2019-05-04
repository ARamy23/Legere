//
//  BaseInteractor.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import RxSwift

class BaseInteractor {
    var cache: CacheProtocol
    
    init(cache: CacheProtocol) {
        self.cache = cache
    }
    
    func execute<T: Codable>(_ model: T) -> Observable<T> {
        do {
            extract()
            try validate()
            return process(model)
        } catch let error {
            return Observable.create({ (observer) -> Disposable in
                observer.on(.error(error))
                return Disposables.create()
            })
        }
    }
    
    func validate() throws {}
    func extract() {}
    
    func process<T: Codable>(_ model: T) -> Observable<T> {
        return Observable.create({ (observer) -> Disposable in
            observer.on(.error(NSError(domain: "Error", code: 100, userInfo: nil)))
            return Disposables.create()
        })
    }
}
