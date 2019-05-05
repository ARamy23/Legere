//
//  DidReadArticleInteractor.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/6/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Promises

final class DidReadArticleInteractor: BaseInteractor {
    let articleId: Int
    init(articleId: Int, base: BaseInteractor){
        self.articleId = articleId
        super.init(network: base.network, cache: base.cache)
    }
    
    override func process<T>(_ model: T.Type) -> Promise<T> where T : Decodable, T : Encodable {
        return network.callModel(model: model, api: ArticlesService.didRead(articleId: articleId))
    }
}
