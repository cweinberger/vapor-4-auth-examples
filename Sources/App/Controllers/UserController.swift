import Fluent
import Vapor

struct UserController {
    func getAll(req: Request) throws -> EventLoopFuture<[User.PublicUser]> {
        guard req.auth.has(User.self) else { throw Abort(.unauthorized) }
        return User.query(on: req.db).all().flatMapThrowing { users in
            return try users.map(User.PublicUser.init)
        }
    }

    func getSingle(req: Request) throws -> EventLoopFuture<User.PublicUser> {
        guard req.auth.has(User.self) else { throw Abort(.unauthorized) }
        return User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { try User.PublicUser($0) }
    }
    
    func create(req: Request) throws -> EventLoopFuture<User.PublicUser> {
        try UserController.CreateUser.validate(req)
        let create = try req.content.decode(UserController.CreateUser.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        let user = try User(
            name: create.name,
            email: create.email,
            passwordHash: Bcrypt.hash(create.password)
        )
        return user.save(on: req.db)
            .flatMapThrowing { try User.PublicUser(user) }
    }
}

extension UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("users", use: getAll)
        routes.get("users", ":userID",  use: getSingle)
        routes.post("users", use: create)
    }
}

extension UserController {
    struct CreateUser: Content {
        var name: String
        var email: String
        var password: String
        var confirmPassword: String
    }
}

extension UserController.CreateUser: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}
