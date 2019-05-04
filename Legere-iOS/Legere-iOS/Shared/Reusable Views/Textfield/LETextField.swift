//
//  LETextField.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit

class LETextField: BaseCustomView {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backgroundView: UIView!
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
    
    init() {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width - 50, height: 50)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
