//
//  ExternalProtocols.swift
//
//  Created by Ahmed Meguid on 12/4/18.
//  Copyright © 2018 Ahmed Meguid. All rights reserved.
//

import UIKit
import Promises

protocol CacheProtocol {
    func getData(key: CachingKey) -> [Data]?
    func saveData(_ data: Data?, key: CachingKey)
    func getObject<T: Codable>(_ object: T, key: CachingKey) -> T?
    func saveObject<T: Codable>(_ object: T, key: CachingKey)
    func removeObject(key: CachingKey)
}

protocol NetworkProtocol {
    func callModel<T: Codable, U: BaseTargetType>(model: T.Type, api: U) -> Promise<T>
}

protocol RouterProtocol {
    var presentedView: BaseViewController! {set get}
    func present(view: BaseViewController)
    func startActivityIndicator()
    func stopActivityIndicator()
    func dismiss()
    func pop()
    func segue(storyboard: AppStoryboard, vc: UIViewController.Type)
    func alert(title: String, message: String, actions: [(title: String, style: UIAlertAction.Style)])
    func toastError(title: String, message: String)
}
