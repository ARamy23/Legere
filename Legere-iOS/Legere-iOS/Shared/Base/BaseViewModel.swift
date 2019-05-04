//
//  BaseViewModel.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation

class BaseViewModel {
    var router: RouterProtocol
    var cache: CacheProtocol
    
    var baseInteractor: BaseInteractor
    
    init(cache: CacheProtocol, router: RouterProtocol) {
        
    }
}
