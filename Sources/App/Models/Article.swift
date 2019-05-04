import FluentPostgreSQL
import Vapor

final class Article: Codable {
    /// ID to article
    /// can be later used in fetching the article through URL
    /// example: to fetch first article there ever was
    /// use this ~> localhost:8080/articles/1
    var id: Int?

    /// Title for the article
    var title: String

    /// Article details you have about this article
    var details: String

    /// we use this as a link between the article and the user
    /// we call this kind of link one to many where
    /// a user (author) can have many articles
    /// but an article can only have one author
    var userID: User.ID
    
    /// Number of reads for this article
    var reads: Int
    
    var likedBy: [User.ID] {
        didSet {
            numberOfLikes = likedBy.count
        }
    }
    
    var numberOfLikes: Int
    
    init(title: String, details: String, userID: User.ID, reads: Int = 0, likedBy: [User.ID] = []) {
        self.title = title
        self.details = details
        self.userID = userID
        self.reads = reads
        self.likedBy = likedBy
        self.numberOfLikes = likedBy.count
    }
}

// extending the Article to a PostgreSQLModel here means that
// this model will be an entity later in the PostgreSQLDataBase
// so you can include it in the migrations
extension Article: PostgreSQLModel {}

// extending the Article to Content here means that
// this model is tirelessly convertable to a JSON to be responded with to
// iOS & Android clients
extension Article: Content {}

// extending the Article to Parameter here means that
// i can use the id of the article i have in the URL and fetch this article
extension Article: Parameter {}

extension Article: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.userID, to: \User.id)
        }
    }
}

extension Article {
    var author: Parent<Article, User> {
        return parent(\.userID)
    }
    
    var categories: Siblings<Article, Category, ArticleCategoryPivot> {
        return siblings()
    }
}
