//
//  ArticleTests.swift
//  AppTests
//
//  Created by Ahmed Ramy on 3/16/19.
//

@testable import App
import Vapor
import XCTest
import FluentPostgreSQL

final class ArticleTests: XCTestCase {
    let articleTitle = "Today I Read About Vapor"
    let articleDetails = "It was such a cool experience!"
    let articlesURI = "/api/articles"
    var app: Application!
    var conn: PostgreSQLConnection!
    
    override func setUp() {
        try! Application.reset()
        app = try! Application.testable()
        conn = try! app.newConnection(to: .psql).wait()
    }
    
    override func tearDown() {
        conn.close()
        try? app.syncShutdownGracefully()
    }
    
    func testArticlesCanBeSavedFromAPI() throws {
        let article = try Article.create(title: articleTitle,
                                         details: articleDetails,
                                         on: conn)
        
        let recievedArticle = try app.getResponse(to: articlesURI, method: .POST,
                                                  headers: ["Content-Type": "application/json"], data: article,
                                                  decodeTo: Article.self, loggedInRequest: true)
        XCTAssertEqual(recievedArticle.title, article.title)
        XCTAssertEqual(recievedArticle.details, article.details)
        XCTAssertNotNil(recievedArticle.id)
        
        let articles = try app.getResponse(to: articlesURI, decodeTo: [Article].self)
        XCTAssertEqual(articles.count, 2)
        XCTAssertEqual(articles[1].title, articleTitle)
        XCTAssertEqual(articles[1].details, articleDetails)
        XCTAssertEqual(articles[1].id, recievedArticle.id)
    }
    
    func testArticlesCanBeRetrievedFromAPI() throws {
        let article1 = try Article.create(title: articleTitle, details: articleDetails, on: conn)
        _ = try Article.create(on: conn)
        
        let articles = try app.getResponse(to: articlesURI, decodeTo: [Article].self)
        
        XCTAssertEqual(articles.count, 2)
        XCTAssertEqual(articles[0].title, articleTitle)
        XCTAssertEqual(articles[0].details, articleDetails)
        XCTAssertEqual(articles[0].id, article1.id)
    }
    
    func testUpdatingAnArticle() throws {
        let article = try Article.create(title: articleTitle, details: articleDetails, on: conn)
        let newUser = try User.create(on: conn)
        let newTitle = "7amada"
        let updatedArticle = Article(title: newTitle, details: articleDetails, userID: newUser.id!, reads: 0)
        
        try app.sendRequest(to: "\(articlesURI)/\(article.id!)", method: .PUT,
                            headers: ["Content-Type": "application/json"], data: updatedArticle, loggedInUser: newUser)
        
        let returnedArticle = try app.getResponse(to: "\(articlesURI)/\(article.id!)", method: .GET, decodeTo: ArticleDetails.self, loggedInRequest: true, loggedInUser: newUser).article
        
        XCTAssertEqual(returnedArticle.title, newTitle)
        XCTAssertEqual(returnedArticle.details, updatedArticle.details)
        XCTAssertEqual(returnedArticle.userID, newUser.id)
    }
    
    func testUpdatingReadsOfAnArticle() throws {
        let article = try Article.create(title: articleTitle, details: articleDetails, on: conn)
        let newUser = try User.create(on: conn)
        try app.sendRequest(to: "\(articlesURI)/\(article.id!)/read", method: .PUT,
                            headers: ["Content-Type": "application/json"], data: article, loggedInUser: newUser)
        let returnedArticle = try app.getResponse(to: "\(articlesURI)/\(article.id!)", method: .GET, decodeTo: ArticleDetails.self, loggedInRequest: true, loggedInUser: newUser).article
        
        XCTAssertEqual(returnedArticle.reads, 1)
    }
    
    func testLikeOfAnArticleAffectsLikesCount() throws {
        let newUser = try User.create(on: conn)
        let article = try Article.create(title: articleTitle, details: articleDetails, user: newUser, on: conn)
        
        let likeData = LikeData(userID: newUser.id!)
        
        try app.sendRequest(to: "\(articlesURI)/\(article.id!)/like", method: .PUT,
                            headers: ["Content-Type": "application/json"], data: likeData, loggedInUser: newUser)
        let returnedArticle = try app.getResponse(to: "\(articlesURI)/\(article.id!)", method: .GET, decodeTo: ArticleDetails.self, loggedInRequest: true, loggedInUser: newUser).article
        
        XCTAssertEqual(returnedArticle.numberOfLikes, 1)
    }
    
    func testUnlikeOfAnArticleAffectsLikesCount() throws {
        let newUser = try User.create(on: conn)
        let article = try Article.create(title: articleTitle, details: articleDetails, user: newUser, on: conn)
        
        let likeData = LikeData(userID: newUser.id!)
        
        try app.sendRequest(to: "\(articlesURI)/\(article.id!)/like", method: .PUT,
                            headers: ["Content-Type": "application/json"], data: likeData, loggedInUser: newUser)
        let returnedArticle = try app.getResponse(to: "\(articlesURI)/\(article.id!)", method: .GET, decodeTo: ArticleDetails.self, loggedInRequest: true, loggedInUser: newUser).article
        
        XCTAssertEqual(returnedArticle.numberOfLikes, 1)
        
        try app.sendRequest(to: "\(articlesURI)/\(article.id!)/like", method: .PUT,
                            headers: ["Content-Type": "application/json"], data: likeData, loggedInUser: newUser)
        let returnedArticle2 = try app.getResponse(to: "\(articlesURI)/\(article.id!)", method: .GET, decodeTo: ArticleDetails.self, loggedInRequest: true, loggedInUser: newUser).article
        
        XCTAssertEqual(returnedArticle2.numberOfLikes, 0)
    }
    
    func testLikeOfAnArticleAffectsArticleDetailsForCurrentUser() throws {
        let newUser = try User.create(on: conn)
        let article = try Article.create(title: articleTitle, details: articleDetails, user: newUser, on: conn)
        
        let likeData = LikeData(userID: newUser.id!)
        
        try app.sendRequest(to: "\(articlesURI)/\(article.id!)/like", method: .PUT,
                            headers: ["Content-Type": "application/json"], data: likeData, loggedInUser: newUser)
        let returnedArticle = try app.getResponse(to: "\(articlesURI)/\(article.id!)", method: .GET, decodeTo: ArticleDetails.self, loggedInRequest: true, loggedInUser: newUser)
        
        
        
        XCTAssertEqual(returnedArticle.article.numberOfLikes, 1)
        XCTAssertTrue(returnedArticle.isLikedByCurrentUser)
    }
    
    func testUnlikeOfAnArticleAffectsArticleDetailsForCurrentUser() throws {
        let newUser = try User.create(on: conn)
        let article = try Article.create(title: articleTitle, details: articleDetails, user: newUser, on: conn)
        
        let likeData = LikeData(userID: newUser.id!)
        
        try app.sendRequest(to: "\(articlesURI)/\(article.id!)/like", method: .PUT,
                            headers: ["Content-Type": "application/json"], data: likeData, loggedInUser: newUser)
        let returnedArticle = try app.getResponse(to: "\(articlesURI)/\(article.id!)", method: .GET, decodeTo: ArticleDetails.self, loggedInRequest: true, loggedInUser: newUser)
        
        XCTAssertEqual(returnedArticle.article.numberOfLikes, 1)
        XCTAssertEqual(returnedArticle.isLikedByCurrentUser, true)
        
        try app.sendRequest(to: "\(articlesURI)/\(article.id!)/like", method: .PUT,
                            headers: ["Content-Type": "application/json"], data: likeData, loggedInUser: newUser)
        let returnedArticle2 = try app.getResponse(to: "\(articlesURI)/\(article.id!)", method: .GET, decodeTo: ArticleDetails.self, loggedInRequest: true, loggedInUser: newUser)
        
        XCTAssertEqual(returnedArticle2.article.numberOfLikes, 0)
        XCTAssertEqual(returnedArticle2.isLikedByCurrentUser, false)
    }
    
    func testDeletingAnArticle() throws {
        let article = try Article.create(on: conn)
        var articles = try app.getResponse(to: articlesURI, decodeTo: [Article].self)
        
        XCTAssertEqual(articles.count, 1)
        
        _ = try app.sendRequest(to: "\(articlesURI)/\(article.id!)", method: .DELETE, loggedInRequest: true)
        articles = try app.getResponse(to: articlesURI, decodeTo: [Article].self)
        
        XCTAssertEqual(articles.count, 0)
    }
    
    func testGettingAnArticlesUser() throws {
        let user = try User.create(on: conn)
        let article = try Article.create(user: user, on: conn)
        
        let author = try app.getResponse(to: "\(articlesURI)/\(article.id!)/user", decodeTo: User.Public.self)
        XCTAssertEqual(author.id, user.id)
        XCTAssertEqual(author.name, user.name)
        XCTAssertEqual(author.username, user.username)
    }
    
    func testArticlesCategories() throws {
        let category = try Category.create(on: conn)
        let category2 = try Category.create(name: "Funny", on: conn)
        let article = try Article.create(on: conn)
        
        _ = try app.sendRequest(to: "\(articlesURI)/\(article.id!)/categories/\(category.id!)",
            method: .POST, loggedInRequest: true)
        _ = try app.sendRequest(to: "\(articlesURI)/\(article.id!)/categories/\(category2.id!)",
            method: .POST, loggedInRequest: true)
        
        let categories = try app.getResponse(to: "\(articlesURI)/\(article.id!)/categories", decodeTo: [App.Category].self)
        
        XCTAssertEqual(categories.count, 2)
        XCTAssertEqual(categories[0].id, category.id)
        XCTAssertEqual(categories[0].name, category.name)
        XCTAssertEqual(categories[1].id, category2.id)
        XCTAssertEqual(categories[1].name, category2.name)
        
        _ = try app.sendRequest(to: "\(articlesURI)/\(article.id!)/categories/\(category.id!)", method: .DELETE,
                                loggedInRequest: true)
        let newCategories = try app.getResponse(to: "\(articlesURI)/\(article.id!)/categories", decodeTo: [App.Category].self)
        
        XCTAssertEqual(newCategories.count, 1)
    }
    
    func testSearchArticle() throws {
        
        let article = try Article.create(on: conn)
        let articles = try app.getResponse(to: "\(articlesURI)/search?term=Today", decodeTo: [Article].self)
        
        XCTAssertEqual(articles.count, 1, "Not match")
        XCTAssertEqual(articles[0].id, article.id, "id not match")
        XCTAssert(articles[0].title.contains(articleTitle), "not close")
        XCTAssert(articles[0].details.contains(articleDetails), "not close")
    }
    
    func testSearchArticleByCategory() throws {
        let category = try Category.create(on: conn)
        let user = try User.create(on: conn)
        let article1 = try Article.create(title: "Today I Read 2", details: "Now am reading about...", user: user, on: conn)
        let article2 = try Article.create(on: conn)
        
        _ = try app.sendRequest(to: "\(articlesURI)/\(article1.id!)/categories/\(category.id!)", method: .POST)
        _ = try app.sendRequest(to: "\(articlesURI)/\(article2.id!)/categories/\(category.id!)", method: .POST)
        
        let articles = try app.getResponse(to: "\(articlesURI)/search?term=Random", decodeTo: [Article].self)
        
//        XCTAssertEqual(articles.count, 2)
//        XCTAssert(articles[0].id == article1.id, "id not match")
//        XCTAssert(articles[1].id == article2.id, "id not match")
//        XCTAssert(articles[0].title.contains(article1.title), "not close")
//        XCTAssert(articles[1].title.contains(article2.title), "not close")
//        XCTAssert(articles[0].details.contains(article1.details), "not close")
//        XCTAssert(articles[1].details.contains(article2.details), "not close")
    }
}
