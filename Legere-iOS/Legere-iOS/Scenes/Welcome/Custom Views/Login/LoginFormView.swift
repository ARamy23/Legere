//
//  LoginFormView.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit

class LoginFormView: BaseCustomView {
    @IBOutlet weak var nameTextField: LETextField!
    @IBOutlet weak var passwordTextfield: LETextField!
    
    var loginAction: ((String, String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextField.textfield.placeholder = "Username"
        passwordTextfield.textfield.placeholder = "Password"
        passwordTextfield.textfield.isSecureTextEntry = true
        
    }
    
    @IBAction func login(_ sender: Any) {
        let username = nameTextField.textfield.text ?? ""
        let password = passwordTextfield.textfield.text ?? ""
        loginAction?(username, password)
    }
    
    init() {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width - 50, height: 50)))
        nameTextField.textfield.placeholder = "Username"
        passwordTextfield.textfield.placeholder = "Password"
        passwordTextfield.textfield.isSecureTextEntry = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
