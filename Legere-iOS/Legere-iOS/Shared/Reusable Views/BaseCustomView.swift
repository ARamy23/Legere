//
//  BaseCustomView.swift
//  Legere
//
//  Created by Ahmed Ramy on 5/3/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit

class BaseCustomView: UIView {
    var viewFromNib: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        viewFromNib = UINib(nibName: getNibName(), bundle: .main).instantiate(withOwner: self, options: nil).first as? UIView
        viewFromNib.frame = bounds
        viewFromNib.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(viewFromNib)
    }
    
    private func getNibName() -> String {
        return String(describing: type(of: self))
    }
}
