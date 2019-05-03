//
//  CategoryController.swift
//  App
//
//  Created by Ahmed Ramy on 3/24/19.
//

import Vapor

struct CategoryController: RouteCollection {
    func boot(router: Router) throws {
        let categoriesRoutes = router.grouped("api", "categories")
        
        // MARK: Public Routes
        categoriesRoutes.get(use: getAllHandler)
        categoriesRoutes.get(Category.parameter, use: getHandler)
        categoriesRoutes.get(Category.parameter, "articles", use: getArticlesHandler)
        
        // MARK: Protected Routes
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let protectedRoutes = categoriesRoutes.grouped([tokenAuthMiddleware, guardAuthMiddleware])
        
        // Create
        protectedRoutes.post(Category.self, use: createHandler)
    }
    
    func createHandler(_ req: Request, category: Category) throws -> Future<Category> {
        return category.save(on: req)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Category]> {
        return Category.query(on: req).all()
    }
    
    func getHandler(_ req: Request) throws -> Future<Category> {
        return try req.parameters.next(Category.self)
    }
    
    func getArticlesHandler(_ req: Request) throws -> Future<[Article]> {
        return try req.parameters.next(Category.self).flatMap(to: [Article].self) { category in
            try category.articles.query(on: req).all()
        }
    }
}
