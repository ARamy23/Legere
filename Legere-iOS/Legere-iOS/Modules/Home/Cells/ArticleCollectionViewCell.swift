//
//  ArticleCollectionViewCell.swift
//  Today-I-Read-App
//
//  Created by Ahmed Ramy on 5/3/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var socialBarView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        socialBarView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}
