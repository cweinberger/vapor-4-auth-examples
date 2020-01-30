import Fluent
import FluentSQLiteDriver
import Vapor

// Called before your application initializes.
public func configure(_ app: Application) throws {
    // Serves files from `Public/` directory
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(UserAuthenticator().middleware())

    // Configure SQLite database
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    // Configure migrations
    app.migrations.add(CreateTodo())
    app.migrations.add(User.Migration())
    
    try routes(app)
}
