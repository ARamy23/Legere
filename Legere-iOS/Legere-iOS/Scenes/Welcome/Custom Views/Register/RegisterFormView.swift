//
//  RegisterFormView.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit

class RegisterFormView: BaseCustomView {
    @IBOutlet weak var usernameTextField: LETextField!
    @IBOutlet weak var nameTextField: LETextField!
    @IBOutlet weak var passwordTextfield: LETextField!
    @IBOutlet weak var confirmPasswordTextfield: LETextField!
    
    var registerAction: ((String, String, String, String) -> Void)?
    
    @IBAction func register(_ sender: Any) {
        let username = usernameTextField.textfield.text ?? ""
        let name = nameTextField.textfield.text ?? ""
        let password = passwordTextfield.textfield.text ?? ""
        let confirmPassword = confirmPasswordTextfield.textfield.text ?? ""
        registerAction?(username, name, password, confirmPassword)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        usernameTextField.textfield.placeholder = "Username"
        nameTextField.textfield.placeholder = "Name"
        passwordTextfield.textfield.placeholder = "Password"
        confirmPasswordTextfield.textfield.placeholder = "Confirm Password"
        passwordTextfield.textfield.isSecureTextEntry = true
        confirmPasswordTextfield.textfield.isSecureTextEntry = true
        
    }
    
    init() {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width - 50, height: 50)))
        usernameTextField.textfield.placeholder = "Username"
        nameTextField.textfield.placeholder = "Name"
        passwordTextfield.textfield.placeholder = "Password"
        confirmPasswordTextfield.textfield.placeholder = "Confirm Password"
        passwordTextfield.textfield.isSecureTextEntry = true
        confirmPasswordTextfield.textfield.isSecureTextEntry = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
