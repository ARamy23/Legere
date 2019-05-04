//
//  Router.swift
//
//  Created by Ahmed Meguid on 12/5/18.
//  Copyright © 2018 Ahmed Meguid. All rights reserved.
//

import UIKit
import SwiftMessages

class Router: RouterProtocol {
    
    var presentedView: BaseViewController!
    
    func present(view: BaseViewController) {
        presentedView.present(view, animated: true, completion: nil)
    }
    
    func startActivityIndicator() { }
    
    func stopActivityIndicator() { }
    
    func dismiss() {
        presentedView.dismiss(animated: true, completion: nil)
    }
    
    func pop() {
        _ = presentedView.navigationController?.popViewController(animated: true)
    }
    
    func segue(storyboard: AppStoryboard, vc: UIViewController.Type) {
        presentedView
            .navigationController?
            .pushViewController(storyboard.viewController(viewControllerClass: vc))
    }
    
    func alert(title: String, message: String, actions: [(title: String, style: UIAlertAction.Style)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.map({UIAlertAction(title: $0.title, style: $0.style, handler: nil)}).forEach({alert.addAction($0)})
        presentedView.present(alert, animated: true)
    }
    
    func toastError(title: String, message: String) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.info)
        view.configureContent(title: title, body: message, iconImage: #imageLiteral(resourceName: "ic_alert_dark"))
        view.configureDropShadow()
        view.button?.isHidden = true
        
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .statusBar)
        config.duration = .seconds(seconds: 3)
        config.interactiveHide = true
        
        
        SwiftMessages.show(config: config, view: view)
    }
}
