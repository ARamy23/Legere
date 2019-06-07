//
//  UserController.swift
//  App
//
//  Created by Ahmed Ramy on 3/18/19.
//

import Vapor
import Crypto

struct UserController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoutes = router.grouped("api", "users")
        
        // MARK: Public Routes
        // Create
        usersRoutes.post(User.self, use: createHandler)
        
        // Read
        usersRoutes.get(use: getAllHandler)
        usersRoutes.get(User.parameter, use: getHandler)
        usersRoutes.get(User.parameter, "articles", use: getAllArticlesForUser)
        
        // MARK: Protected Routes
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
        let basicAuthGroup = usersRoutes.grouped(basicAuthMiddleware)
        
        // Create
        basicAuthGroup.post("login", use: loginHandler)
        
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMidlleware = User.guardAuthMiddleware()
        let protectedRoutes = usersRoutes.grouped([tokenAuthMiddleware, guardAuthMidlleware])
        
        // Read
        protectedRoutes.get("profile", use: getProfile)
        
        // Update
        protectedRoutes.put(User.parameter, use: updateHandler)
        protectedRoutes.put(User.parameter, "profilePicture", use: addProfilePictureHandler)
        
        // Update
        protectedRoutes.delete(User.parameter, use: deleteHandler)
    }
    
    // MARK: - Create
    
    func createHandler(_ req: Request, user: User) throws -> Future<User.Public> {
        user.password = try BCrypt.hash(user.password)
        return user.save(on: req).convertToPublic()
    }
    
    // MARK: - Read
    
    func getAllHandler(_ req: Request) throws -> Future<[User.Public]> {
        return User.query(on: req).all().map { $0.map { $0.convertToPublic() } }
    }
    
    func getHandler(_ req: Request) throws -> Future<User.Public> {
        return try req.parameters.next(User.self).convertToPublic()
    }
    
    func getAllArticlesForUser(_ req: Request) throws -> Future<[Article]> {
        return try req.parameters.next(User.self).flatMap({ (user) in
            return try user.articles.query(on: req).all()
        })
    }
    
    func getProfile(_ req: Request) throws -> Future<User.Public> {
        return try req.requireAuthenticated(User.self).save(on: req).convertToPublic()
    }
    
    func loginHandler(_ req: Request) throws -> Future<Token> {
        let user = try req.requireAuthenticated(User.self)
        let token = try Token.generate(for: user)
        return token.save(on: req)
    }
    
    // MARK: - Update
    func updateHandler(_ req: Request) throws -> Future<User.Public> {
        return try flatMap(
            to: User.Public.self,
            req.parameters.next(User.self),
            req.content.decode(User.self)) { (oldUser, newUser) in
                oldUser.name = newUser.name
                oldUser.username = newUser.username
                oldUser.password = try BCrypt.hash(newUser.password)
                return oldUser.save(on: req).convertToPublic()
        }
    }
    
    func addProfilePictureHandler(_ req: Request) throws -> Future<User.Public> {
        return try flatMap(to: User.Public.self,
           req.parameters.next(User.self),
           req.content.decode(ProfilePictureUploadData.self)) { (user, imageString) in
                user.profilePicture = imageString.profilePicture
            return user.save(on: req).convertToPublic()
        }
    }
    
    // MARK: - Delete
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req
            .parameters
            .next(User.self)
            .delete(on: req)
            .transform(to: .noContent)
    }
}

struct ProfilePictureUploadData: Content {
    let profilePicture: String
}
