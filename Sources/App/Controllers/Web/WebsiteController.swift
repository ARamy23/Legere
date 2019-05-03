
import Vapor
import Leaf

struct WebsiteController: RouteCollection {
    func boot(router: Router) throws {
        router.get(use: indexHandler)
        router.get("articles", Article.parameter, use: articleHandler)
    }
    
    func indexHandler(_ req: Request) throws -> Future<View> {
        return Article.query(on: req).all().flatMap(to: View.self) { articles in
            let context = IndexContext(title: "Home page", articles: articles)
            return try req.view().render("index", context)
        }
    }
    
    func articleHandler(_ req: Request) throws -> Future<View> {
        return try req.parameters.next(Article.self).flatMap(to: View.self) { article in
            return article.author.get(on: req).flatMap(to: View.self) { author in
                let context = ArticleContext(title: article.title, article: article, author: author)
                
                return try req.view().render("article", context)
            }
        }
    }
}

struct IndexContext: Encodable {
    let title: String
    let articles: [Article]?
}

struct ArticleContext: Encodable {
    let title: String
    let article: Article
    let author: User
}
