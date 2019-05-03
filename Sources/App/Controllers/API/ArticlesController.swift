import Fluent
import Vapor
import Authentication

struct ArticlesController: RouteCollection {
    func boot(router: Router) throws {
        let articlesRoutes = router.grouped("api", "articles")

        // MARK: Public Routes
        // Read
        articlesRoutes.get(use: getAllHandler)
        articlesRoutes.get(Article.parameter, use: getHandler)
        articlesRoutes.get(Article.parameter, "user", use: getUserHandler)
        articlesRoutes.get("search", use: searchHandler)
        articlesRoutes.get(Article.parameter, "categories", use: getCategoriesHandler)
        
        // MARK: Protected Routes
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMidlleware = User.guardAuthMiddleware()
        let protectedRoutes = articlesRoutes.grouped([tokenAuthMiddleware, guardAuthMidlleware])
        
        // Create
        protectedRoutes.post(ArticleCreateData.self, use: createHandler)
        protectedRoutes.post(Article.parameter, "categories", Category.parameter, use: addCategoriesHandler)
        
        // Update
        protectedRoutes.put(Article.parameter, use: updateHandler)
        
        // Delete
        protectedRoutes.delete(Article.parameter, use: deleteHandler)
        protectedRoutes.delete(Article.parameter, "categories", Category.parameter, use: removeCategoriesHandler)
    }

    // MARK: - Create

    func createHandler(_ req: Request, articleData: ArticleCreateData) throws -> Future<Article> {
        let user = try req.requireAuthenticated(User.self)
        let article = try Article(title: articleData.title, details: articleData.details, userID: user.requireID())
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

    func getHandler(_ req: Request) throws -> Future<Article> {
        return try req // 1 ~> We take the request
            .parameters // 2 ~> we cut it down and get the parameter (...articles/`1`)
            .next(Article.self) // 3 ~> we map that parameter into the Article type
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
}
