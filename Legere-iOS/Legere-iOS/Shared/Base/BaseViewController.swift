//
//  BaseViewController.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var cache: CacheProtocol = UserDefaultsManager()
    var network: NetworkProtocol = MoyaManager()
    var router: RouterProtocol = Router()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router.presentedView = self
        bind()
    }
    
    func initialize() {}
    func bind() {}
}
