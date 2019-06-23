import Fluent
import Vapor
import Authentication

struct ArticlesController: RouteCollection {
    func boot(router: Router) throws {
        let articlesRoutes = router.grouped("api", "articles")

        // MARK: Public Routes
        // Read
        articlesRoutes.get(use: getAllHandler)
        articlesRoutes.get(Article.parameter, "user", use: getUserHandler)
        articlesRoutes.get("search", use: searchHandler)
        articlesRoutes.get(Article.parameter, "categories", use: getCategoriesHandler)
        
        // MARK: Protected Routes
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMidlleware = User.guardAuthMiddleware()
        let protectedRoutes = articlesRoutes.grouped([tokenAuthMiddleware, guardAuthMidlleware])
        
        // Read
        
        protectedRoutes.get(Article.parameter, use: getHandler)
        
        // Create
        protectedRoutes.post(ArticleCreateData.self, use: createHandler)
        protectedRoutes.post(Article.parameter, "categories", Category.parameter, use: addCategoriesHandler)
        
        // Update
        protectedRoutes.put(Article.parameter, use: updateHandler)
        protectedRoutes.put(Article.parameter, "read", use: didReadHandler)
        protectedRoutes.put(Article.parameter, "like", use: likeHandler)
        protectedRoutes.put(Article.parameter, "unlike", use: unlikeHandler)
        
        // Delete
        protectedRoutes.delete(Article.parameter, use: deleteHandler)
        protectedRoutes.delete(Article.parameter, "categories", Category.parameter, use: removeCategoriesHandler)
    }

    // MARK: - Create

    func createHandler(_ req: Request, articleData: ArticleCreateData) throws -> Future<Article> {
        let userID = try req.requireAuthenticated(User.self).requireID()
        let article = Article(title: articleData.title, details: articleData.details, userID: userID, reads: 0, numberOfLikes: 0, coverPhoto: articleData.coverPhoto)
        return article.save(on: req)
    }
    
    func addCategoriesHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try flatMap(to: HTTPStatus.self, req.parameters.next(Article.self),
                           req.parameters.next(Category.self)) { article, category in
                            return article.categories.attach(category, on: req).transform(to: .created)
        }
    }

    // MARK: - Read

    func getAllHandler(_ req: Request) throws -> Future<[Article]> {
        return Article // 1 ~> We get the Entity called `Article`
            .query(on: req) // 2 ~> We Query on that is in our PostgreSQL DB
            .all() // 3 ~> We Specify to get everything
    }

    func getHandler(_ req: Request) throws -> Future<Article.Details> {
        let user = try req.requireAuthenticated(User.self)
        return try req.parameters.next(Article.self).then { article in
            return user.likes.isAttached(article, on: req).map(to: Article.Details.self) { hasLikedBefore in
                return Article.Details(article: article, isLikedByCurrentUser: hasLikedBefore)
            }
        }
    }
    
    func searchHandler(_ req: Request) throws -> Future<[Article]> {
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        
        let articleSearchQuery = Article.query(on: req).group(.or) { or in
            or.filter(\.title, .like, "%\(searchTerm)%")
            or.filter(\.details, .like, "%\(searchTerm)%")
            }.all()
        
        return Category.query(on: req)
            .filter(\.name, .like, "%\(searchTerm)%")
            .all().flatMap(to: [Article].self) { categories in
                // categories.map returns an array of Future<[Articles]>
                // which is [Future<Articles>]
                // flattening the result, you will have Future<[[Articles]]>
                let categoriesQuery = try categories.map { try $0.articles.query(on: req).all() }.flatten(on: req)
                return map(to: [Article].self,
                           articleSearchQuery,
                           categoriesQuery) { articlesFromSearchTerm, articlesFromCategories in
                            // articlesFromCategories is [[Articles]]
                            var allArticles: [Article] = []
                            articlesFromCategories.forEach { articles in
                                allArticles += articles
                            }
                            allArticles += articlesFromSearchTerm
                            return allArticles
                }
        }
    }
    
    func getUserHandler(_ req: Request) throws -> Future<User.Public> {
        return try req.parameters.next(Article.self).flatMap(to: User.Public.self) { article in
            article.author.get(on: req).convertToPublic()
        }
    }
    
    func getCategoriesHandler(_ req: Request) throws -> Future<[Category]> {
        return try req.parameters.next(Article.self).flatMap(to: [Category].self) { article in
            try article.categories.query(on: req).all()
        }
    }

    // MARK: - Update

    func updateHandler(_ req: Request) throws -> Future<Article> {
        return try flatMap( // 1 ~> we create a future
            to: Article.self, // 2 ~> we map the output to the an `Article`
            req // 3 ~> we grab the request
                .parameters // 3.1 ~> cut it down to get the parameter (...articles/`1`)
                .next(Article.self), // 3.2 ~> we map that parameter into the Article type
            req // 4 ~> in parallel, we also get...
                .content // 4.1 ~> the request body contains new article data
                .decode(ArticleCreateData.self), // 4.2 ~> then we decode that data into an Article
            { article, updateData in // 5 ~> now we have old and new articles
                article.title = updateData.title // 6 ~> Map new to old
                article.details = updateData.details // still mapping...
                let user = try req.requireAuthenticated(User.self)
                article.userID = try user.requireID()
                return article.save(on: req) // 7 ~> save the old article to DB
            }
        )
    }
    
    func didReadHandler(_ req: Request) throws -> Future<Article.Details> {
        let user = try req.requireAuthenticated(User.self)
        return try req.parameters.next(Article.self).flatMap(to: Article.Details.self) { (article) in
            article.reads += 1
            return map(to: Article.Details.self, article.save(on: req), article.likers.isAttached(user, on: req)) { article, isLikedByCurrentUser in
                return Article.Details(article: article, isLikedByCurrentUser: isLikedByCurrentUser)
            }
        }
    }
    
    func likeHandler(_ req: Request) throws -> Future<Article.Details> {
        let user = try req.requireAuthenticated(User.self)
        return try req.parameters.next(Article.self).flatMap(to: Article.Details.self) { article in
            return article.likers.attach(user, on: req).flatMap(to: Article.Details.self) { pivot in
                article.numberOfLikes += 1
                return article.save(on: req).map(to: Article.Details.self, { (article) in
                    return Article.Details(article: article, isLikedByCurrentUser: true)
                })
            }
        }
    }
    
    func unlikeHandler(_ req: Request) throws -> Future<Article.Details> {
        let user = try req.requireAuthenticated(User.self)
        return try req.parameters.next(Article.self).flatMap(to: Article.Details.self) { (article) in
            return article.likers.detach(user, on: req).flatMap(to: Article.Details.self) { _ in
                guard article.numberOfLikes > 0 else { throw Abort(.expectationFailed) }
                article.numberOfLikes -= 1
                return article.save(on: req).map(to: Article.Details.self, { (article) in
                    return Article.Details(article: article, isLikedByCurrentUser: false)
                })
            }
        }
    }
    
    // MARK: - Delete
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req // 1 ~> we grab the request
            .parameters // 2 ~> we cut it down to get the parameter (...articles/`1`)
            .next(Article.self) // 3 ~> we map that parameter into the Article type
            .delete(on: req) // 4 ~> DELETE! KILL! KILL!
            .transform(to: .noContent) // 5 ~> reply with statusCode `204` meaning that noContent and it's been deleted (not to be mistaken with 404)
    }
    
    func removeCategoriesHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try flatMap(to: HTTPStatus.self, req.parameters.next(Article.self),
                           req.parameters.next(Category.self)) { article, category in
                            return article.categories.detach(category, on: req).transform(to: .noContent)
        }
    }
}

struct ArticleCreateData: Content {
    let title: String
    let details: String
    let coverPhoto: String?
}

struct LikeData: Content {
    let userID: User.ID
}
