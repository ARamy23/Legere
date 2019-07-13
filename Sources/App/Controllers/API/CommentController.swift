//
//  CommentController.swift
//  App
//
//  Created by Ahmed Ramy on 7/12/19.
//

import Vapor

struct CommentController: RouteCollection {
    func boot(router: Router) throws {
        let commentsRoutes = router.grouped("api", "comments")
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let protectedRoutes = commentsRoutes.grouped([tokenAuthMiddleware, guardAuthMiddleware])
        
        // MARK: - Protected Routes
        // Create
        protectedRoutes.post(Comment.self, use: createHandler)
    }
    
    func createHandler(_ req: Request, comment: Comment) -> Future<HTTPStatus> {
        return comment.save(on: req).transform(to: .ok)
    }
}
