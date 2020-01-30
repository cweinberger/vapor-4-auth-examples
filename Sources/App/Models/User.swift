import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"

    @ID(key: "id")
    var id: Int?

    @Field(key: "name")
    var name: String

    @Field(key: "email")
    var email: String

    @Field(key: "password_hash")
    var passwordHash: String

    init() { }

    init(id: Int? = nil, name: String, email: String, passwordHash: String) {
        self.id = id
        self.name = name
        self.email = email
        self.passwordHash = passwordHash
    }
}

extension User {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("users")
                .field("id", .int, .identifier(auto: true))
                .field("name", .string, .required)
                .field("email", .string, .required)
                .field("password_hash", .string, .required)
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("users").delete()
        }
    }
}

extension User {
    struct PublicUser: Content {
        var id: Int
        var name: String

        init(_ user: User) throws {
            self.id = try user.requireID()
            self.name = user.name
        }
    }
}

extension User: Authenticatable { }
