//
//  CategoryTests.swift
//  App
//
//  Created by Ahmed Ramy on 3/24/19.
//

import Vapor
import XCTest
import FluentPostgreSQL
@testable import App

final class CategoryTests: XCTestCase {
    let categoryName = "Productivity"
    let categoriesURI = "/api/categories"
    
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
    
    func testCategoriesCanBeSavedFromAPI() throws {
        let category = Category(name: categoryName)
        let receivedCategory = try app.getResponse(to: categoriesURI, method: .POST,
                                                   headers: ["Content-Type": "application/json"],
                                                   data: category, decodeTo: Category.self, loggedInRequest: true)
        
        XCTAssertEqual(receivedCategory.name, categoryName)
        XCTAssertNotNil(receivedCategory.id)
        
        let categories = try app.getResponse(to: categoriesURI, decodeTo: [App.Category].self)
        
        XCTAssertEqual(categories.count, 1)
        XCTAssertEqual(categories[0].name, categoryName)
        XCTAssertEqual(categories[0].id, receivedCategory.id)
    }
    
    func testCategoriesCanBeRetrievedFromAPI() throws {
        let category = try Category.create(name: categoryName, on: conn)
        
        _ = try Category.create(on: conn)
        
        let categories = try app.getResponse(to: categoriesURI, decodeTo: [App.Category].self)
        
        XCTAssertEqual(categories.count, 2)
        XCTAssertEqual(categories[0].name, category.name)
        XCTAssertEqual(categories[0].id, category.id)
    }
    
    static let allTests = [
        ("testCategoriesCanBeSavedFromAPI", testCategoriesCanBeSavedFromAPI),
        ("testCategoriesCanBeRetrievedFromAPI", testCategoriesCanBeRetrievedFromAPI)
    ]
}
