//
//  AuthenticationViewController.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var loginRoundView: UIView!
    @IBOutlet weak var registerRoundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginRoundView.cornerRadius = loginRoundView.height / 2
        registerRoundView.cornerRadius = registerRoundView.height / 2
    }
}
