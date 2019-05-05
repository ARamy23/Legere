//
//  ArticleDetailsViewController.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/5/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit

class ArticleDetailsViewController: BaseViewController {
    
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleBodyTextView: UITextView!
    @IBOutlet weak var peopleLikedThisLabel: UILabel!
    
    @IBOutlet weak var peopleBarView: UIView!
    @IBOutlet weak var peopleBarRoundView: UIView!
    @IBOutlet weak var includingYouBarRoundView: UIView!
    @IBOutlet weak var includingYouView: UIView!
    @IBOutlet weak var socialViewStackView: UIStackView!
    @IBOutlet weak var isLovedImageView: UIImageView!
    
    var viewModel: HomeViewModel!
    var articleDetails: ArticleDetails! {
        didSet {
            articleTitleLabel?.text = articleDetails.article?.title
            articleBodyTextView?.text = articleDetails.article?.details
            isLovedImageView?.image = (articleDetails.isLikedByCurrentUser == true) ? #imageLiteral(resourceName: "ic_love") : #imageLiteral(resourceName: "ic_love_unselected")
            let numberOfLikes = articleDetails.article?.numberOfLikes ?? 0
            peopleLikedThisLabel?.text = "\(numberOfLikes) People Liked This"
            
            peopleBarView?.isHidden = numberOfLikes < 1
            includingYouView?.isHidden = articleDetails.isLikedByCurrentUser != true
        }
    }
    
    override func initialize() {
        super.initialize()
        peopleBarRoundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        includingYouBarRoundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        socialViewStackView.subviews.enumerated().forEach { (arg) in
            let (index, view) = arg
            view.layer.zPosition = 3 - CGFloat(index)
        }
    }
    
    override func bind() {
        viewModel.getArticleDetails(articleDetails.article!)
        viewModel.articleDetails.subscribe(onNext: { [weak self] articleDetails in
            guard let self = self else { return }
            self.articleDetails = articleDetails
        }).disposed(by: disposeBag)
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        router.dismiss()
    }
    
    @IBAction func loveButtonTapped(_ sender: Any) {
        
    }
}
