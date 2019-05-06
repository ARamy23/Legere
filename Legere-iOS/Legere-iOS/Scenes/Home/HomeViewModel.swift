//
//  HomeViewModel.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/5/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import RxSwift
import Promises

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
            }.catch(handleError)
    }
    
    func getArticleDetails(_ articleId: Int) {
        ArticleDetailsInteractor(articleId: articleId, base: baseInteractor)
            .execute(ArticleDetails.self)
            .then { [weak self] articleDetails in
            guard let self = self else { return }
            self.articleDetails.onNext(articleDetails)
            }.catch(handleError)
    }
    
    func didRead(_ articleId: Int) {
        DidReadArticleInteractor(articleId: articleId, base: baseInteractor)
            .execute(ArticleDetails.self).then { [weak self] (articleDetails) in
                guard let self = self else { return }
                self.articleDetails.onNext(articleDetails)
            }.catch { [weak self] (error) in
                guard let self = self else { return }
                self.router.toastError(title: "Error", message: error.localizedDescription)
        }.catch(handleError)
    }
    
    func didLike(_ articleId: Int) {
        DidLikeArticleInteractor(articleId: articleId, base: baseInteractor).execute(ArticleDetails.self).then { [weak self] (articleDetails) in
            guard let self = self else { return }
            self.articleDetails.onNext(articleDetails)
        }.catch(handleError)
    }
}
