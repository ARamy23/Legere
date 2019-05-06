//
//  ArticleDetailsViewController.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/5/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit

final class ArticleDetailsViewController: BaseViewController {
    
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
    var articleDetails: ArticleDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHero()
        self.configureViewFromModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func initialize() {
        super.initialize()
        peopleBarRoundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        includingYouBarRoundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        socialViewStackView.subviews.enumerated().forEach { (arg) in
            let (index, view) = arg
            view.layer.zPosition = 3 - CGFloat(index)
        }
        
        guard let articleId = articleDetails.article?.id else { return }
        didRead(articleId: articleId)
    }
    
    func setupHero() {
        self.hero.isEnabled = true
        self.view.hero.id = "ironMan"
    }
    
    func configureViewFromModel() {
        guard let article = articleDetails.article else { return }
        articleTitleLabel?.text = article.title
        articleBodyTextView?.text = article.details
        isLovedImageView?.image = (articleDetails.isLikedByCurrentUser == true) ? #imageLiteral(resourceName: "ic_love") : #imageLiteral(resourceName: "ic_love_unselected")
        let numberOfLikes = article.numberOfLikes
        peopleLikedThisLabel?.text = "\(numberOfLikes) People Liked This"
        
        peopleBarView?.isHidden = numberOfLikes < 1
        includingYouView?.isHidden = articleDetails.isLikedByCurrentUser != true
    }
    
    override func bind() {
        if let articleId = articleDetails.article?.id {
            viewModel.getArticleDetails(articleId)
        }
        viewModel.articleDetails
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] articleDetails in
                guard let self = self, articleDetails.article != nil else { return }
                self.articleDetails = articleDetails
                self.configureViewFromModel()
            }).disposed(by: disposeBag)
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        router.dismiss()
    }
    
    @IBAction func loveButtonTapped(_ sender: Any) {
        guard let articleId = articleDetails.article?.id else { return }
        viewModel.didLike(articleId)
    }
    
    fileprivate func didRead(articleId: Int) {
        viewModel.didRead(articleId)
    }
}
