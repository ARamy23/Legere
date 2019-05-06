//
//  LETextField.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit

final class LETextField: BaseCustomView {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var showHideEntryButton: UIButton!
    @IBOutlet weak var textfield: UITextField!
    
    @IBInspectable var darkMood: Bool = false {
        didSet {
            if darkMood {
                shadowView.shadowColor = .white
                shadowView.shadowOpacity = 1
                shadowView.shadowOffset = .zero
                textfield.setPlaceHolderTextColor(.black)
            } else {
                shadowView.shadowColor = .black
                shadowView.shadowOpacity = 0.16
                shadowView.shadowOffset = CGSize(width: 0, height: 9)
                textfield.setPlaceHolderTextColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 0.5))
            }
        }
    }
    
    @IBInspectable var isSensetiveDataField: Bool = false {
        didSet {
            textfield.isSecureTextEntry = isSensetiveDataField
            showHideEntryButton.isHidden = !isSensetiveDataField
        }
    }
    
    @IBAction func showHideEntry() {
        textfield.isSecureTextEntry.toggle()
        let image = (textfield.isSecureTextEntry) ? #imageLiteral(resourceName: "ic_read") : #imageLiteral(resourceName: "ic_hide_password")
        showHideEntryButton.setImage(image, for: .normal)
    }
    
    init() {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width - 50, height: 50)))
        if #available(iOS 12, *) {
            // iOS 12: Not the best solution, but it works.
            textfield.textContentType = .oneTimeCode
        } else {
            // iOS 11: Disables the autofill accessory view.
            // For more information see the explanation below.
            textfield.textContentType = .init(rawValue: "")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if #available(iOS 12, *) {
            // iOS 12: Not the best solution, but it works.
            textfield.textContentType = .oneTimeCode
        } else {
            // iOS 11: Disables the autofill accessory view.
            // For more information see the explanation below.
            textfield.textContentType = .init(rawValue: "")
        }
    }
}
