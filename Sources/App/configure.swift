import FluentPostgreSQL
import Leaf
import Vapor
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    //  Vapor providers are a convenient way to add functionality to your Vapor projects. For a full list of providers, check out the vapor-service tag on GitHub.
    try services.register(FluentPostgreSQLProvider())
    try services.register(LeafProvider())
    try services.register(AuthenticationProvider())
    
    // Register routes to the router
    //  Routing is the process of finding the appropriate response to an incoming request.
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Register middleware
    // Middleware is a logic chain between the client and a Vapor route handler. It allows you to make operations on incoming requests before they get to the route handler, and on outgoing responses before they go to the client.
    // For example, a Middleware for determining a web request from a mobile request
    // Another one would be to handle Stripe Requests (something like Payfort but better)
    
    services.register(LogMiddleware.self)
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(LogMiddleware.self)
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    // Configure databases
    var databases = DatabasesConfig()
    
    let postgreDatabase = configurePostgreDatabase(env)
    
    // Register the configured Postgre database to the database config.
    // why do we need to register our Configured Database?
    // because without doing so, it's exactly like making a function and forgetting to
    // call it :)
    // this would later cause weird errors like 404s and 500s cuz u r trying to
    // interact with a db that's not linked to ur project
    databases.add(database: postgreDatabase, as: .psql)
    
    services.register(databases)
    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Article.self, database: .psql)
    migrations.add(model: Category.self, database: .psql)
    migrations.add(model: ArticleCategoryPivot.self, database: .psql)
    migrations.add(model: Token.self, database: .psql)
    migrations.add(migration: AdminUser.self, database: .psql)
    services.register(migrations)
    
    var commandConfig = CommandConfig.default()
    commandConfig.useFluentCommands()
    services.register(commandConfig)
    
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
}

private func configurePostgreDatabase(_ env: Environment) -> PostgreSQLDatabase {
    let databaseName: String
    let databasePort: Int
    let hostName = "localhost"
    let dbUsername = "aramy"
    let password = "password"
    
    if env == .testing {
        databaseName = "legere-testing"
        databasePort = 5433
    } else {
        databaseName = "legere-staging"
        databasePort = 5432
    }
    
    let postgreConfig = PostgreSQLDatabaseConfig(hostname: hostName,
                                                 port: databasePort,
                                                 username: dbUsername,
                                                 database: databaseName,
                                                 password: password)
    return PostgreSQLDatabase(config: postgreConfig)
}
