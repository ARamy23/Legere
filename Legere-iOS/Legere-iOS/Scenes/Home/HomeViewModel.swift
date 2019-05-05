//
//  HomeViewModel.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/5/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import RxSwift

final class HomeViewModel: BaseViewModel {
    var articles: BehaviorSubject<Articles> = BehaviorSubject<Articles>(value: [])
    var articleDetails: PublishSubject<ArticleDetails> = PublishSubject<ArticleDetails>()
    override init(cache: CacheProtocol, router: RouterProtocol, network: NetworkProtocol) {
        super.init(cache: cache, router: router, network: network)
        articles.onNext(self.cache.getObject(Articles.self, key: .articles) ?? [])
    }
    
    func getAllArticles() {
        AllArticlesInteractor(base: baseInteractor).execute(Articles.self).then { [weak self] articles in
            guard let self = self else { return }
            if articles.count <= 10 {
                self.cache.saveObject(articles, key: .articles)
            }
            self.articles.onNext(articles)
            }.catch { (error) in
                self.router.toastError(title: "Error", message: error.localizedDescription)
        }
    }
    
    func getArticleDetails(_ article: Article) {
        articleDetails.onNext(ArticleDetails(article: article))
        ArticleDetailsInteractor(articleId: article.id ?? 0, base: baseInteractor)
            .execute(ArticleDetails.self)
            .then { [weak self] articleDetails in
            guard let self = self else { return }
            self.articleDetails.onNext(articleDetails)
            }.catch { (error) in
                self.router.toastError(title: "Error", message: error.localizedDescription)
        }
    }
    
    func didRead(_ articleId: Int) {
        
    }
}
