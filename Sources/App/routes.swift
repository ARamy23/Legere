import Vapor

public func routes(_ router: Router) throws {
    // Routing through Controllers
    let controllers: [RouteCollection] = [ArticlesController(),
                                          UserController(),
                                          CategoryController(),
                                          WebsiteController()]
    
    try controllers.forEach { try router.register(collection: $0) }
}
