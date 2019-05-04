//
//  AuthenticationViewController.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit
import SwiftEntryKit

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
        
        attributes.screenInteraction = .dismiss
        
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
    
    @IBAction private func didTapLogin(_ sender: Any) {
        let loginFormView = LoginFormView()
        
        SwiftEntryKit.display(entry: loginFormView, using: configurePopupAttributes(
            backgroundStyle: .regular,
            animationStartPosition: .top,
            animationEndPosition: .bottom,
            shadow: .init(color: .black, opacity: 0.16, radius: 12, offset: .zero)))
    }
    
    @IBAction private func didTapRegister(_ sender: Any) {
        let registerFormView = RegisterFormView()
        let attributes = configurePopupAttributes(
            backgroundStyle: .dark,
            animationStartPosition: .bottom,
            animationEndPosition: .top,
            shadow: .init(color: .black, opacity: 1, radius: 20, offset: .zero))
        
        SwiftEntryKit.display(entry: registerFormView, using: attributes)
    }
}
