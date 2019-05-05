//
//  AuthenticationViewController.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit
import SwiftEntryKit
import SimpleTwoWayBinding

final class AuthenticationViewController: BaseViewController {
    
    @IBOutlet weak var loginRoundView: UIView!
    @IBOutlet weak var registerRoundView: UIView!
    
    let loginFormView = LoginFormView()
    let registerFormView = RegisterFormView()
    
    var loginViewModel: LoginViewModel!
    var registerViewModel: RegisterViewModel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateComponents()
    }
    
    override func initialize() {
        super.initialize()
        loginRoundView.cornerRadius = loginRoundView.height / 2
        registerRoundView.cornerRadius = registerRoundView.height / 2
        prepareComponentsForAnimation()
    }
    
    fileprivate func bindLoginFlow() {
        loginViewModel = LoginViewModel(cache: cache, router: router, network: network)
        loginFormView.usernameTextField.textfield.bind(with: loginViewModel.username)
        loginFormView.passwordTextfield.textfield.bind(with: loginViewModel.password)
        
        loginFormView.loginAction = { [weak self] in
            guard let self = self else { return }
            self.loginViewModel.login()
        }
    }
    
    fileprivate func bindRegisterFlow() {
        registerViewModel = RegisterViewModel(cache: cache, router: router, network: network)
        registerFormView.usernameTextField.textfield.bind(with: registerViewModel.username)
        registerFormView.nameTextField.textfield.bind(with: registerViewModel.name)
        registerFormView.passwordTextfield.textfield.bind(with: registerViewModel.password)
        registerFormView.confirmPasswordTextfield.textfield.bind(with: registerViewModel.confirmPassword)
        
        registerFormView.registerAction = { [weak self] in
            guard let self = self else { return }
            self.registerViewModel.register()
        }
    }
    
    override func bind() {
        super.bind()
        bindLoginFlow()
        bindRegisterFlow()
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        SwiftEntryKit.display(entry: loginFormView, using: configurePopupAttributes(
            backgroundStyle: .regular,
            animationStartPosition: .top,
            animationEndPosition: .bottom,
            shadow: .init(color: .black, opacity: 0.16, radius: 12, offset: .zero)))
    }
    
    @IBAction func didTapRegister(_ sender: Any) {
        let attributes = configurePopupAttributes(
            backgroundStyle: .dark,
            animationStartPosition: .bottom,
            animationEndPosition: .top,
            shadow: .init(color: .black, opacity: 1, radius: 20, offset: .zero))
        
        SwiftEntryKit.display(entry: registerFormView, using: attributes)
    }
}


// MARK : - Popup Configurations
extension AuthenticationViewController {
    private func configurePopupAttributes(backgroundStyle: UIBlurEffect.Style, animationStartPosition: EKAttributes.Animation.Translate.AnchorPosition, animationEndPosition: EKAttributes.Animation.Translate.AnchorPosition, shadow: EKAttributes.Shadow.Value) -> EKAttributes {
        var attributes = EKAttributes()
        
        attributes.position = .center
        
        attributes.displayDuration = .infinity
        
        attributes.entryBackground = EKAttributes.BackgroundStyle.visualEffect(style: backgroundStyle)
        
        attributes.screenBackground = EKAttributes.BackgroundStyle.visualEffect(style: backgroundStyle)
        
        attributes.shadow = .active(with: shadow)
        
        attributes.roundCorners = .all(radius: 32)
        
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width - 50), height: .intrinsic)
        
        attributes.entryInteraction = .absorbTouches
        
        attributes.screenInteraction = .absorbTouches
        
        attributes.entranceAnimation = .init(
            translate: .init(duration: 0.7, anchorPosition: animationStartPosition, spring: .init(damping: 1, initialVelocity: 0)),
            scale: .init(from: 0.6, to: 1, duration: 0.7),
            fade: .init(from: 0.8, to: 1, duration: 0.3))
        
        attributes.exitAnimation = .init(translate: .init(duration: 0.7, anchorPosition: animationEndPosition, spring: .init(damping: 1, initialVelocity: 0)), scale: nil, fade: nil)
        
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: 20)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        attributes.positionConstraints.keyboardRelation = keyboardRelation
        
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        
        return attributes
    }
}

// MARK: - Animations Logic
extension AuthenticationViewController {
    fileprivate func animateComponents() {
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.loginRoundView.transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 1.8, delay: 0.2, usingSpringWithDamping: 0.25, initialSpringVelocity: 0.75, options: .curveEaseOut, animations: {
            self.registerRoundView.transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.375) {
            self.loginRoundView.alpha = 1
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.2, animations: {
            self.registerRoundView.alpha = 1
        })
    }
    
    fileprivate func prepareComponentsForAnimation() {
        loginRoundView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        loginRoundView.alpha = 0
        
        registerRoundView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        registerRoundView.alpha = 0
    }
}
