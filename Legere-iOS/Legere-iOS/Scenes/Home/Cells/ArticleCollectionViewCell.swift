//
//  ArticleCollectionViewCell.swift
//  Legere
//
//  Created by Ahmed Ramy on 5/3/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var socialBarView: UIView!
    
    @IBOutlet weak var readCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var breifTextView: UITextView!
    
    var article: Article? {
        didSet {
            readCountLabel.text = "\(article?.reads ?? 0)"
            likesCountLabel.text = "\(article?.numberOfLikes ?? 0)"
            titleLabel.text = "\(article?.title ?? "")"
            breifTextView.text = "\(article?.details ?? "")"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        socialBarView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}
