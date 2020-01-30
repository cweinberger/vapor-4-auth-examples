import Fluent
import Vapor

struct UserAuthenticator: BasicAuthenticator {

    typealias User = App.User

    func authenticate(basic: BasicAuthorization, for request: Request) -> EventLoopFuture<UserAuthenticator.User?> {
        return User.query(on: request.db)
            .filter(\.$email == basic.username)
            .first()
            .flatMapThrowing { user in
                guard let user = user else { return nil }
                guard try Bcrypt.verify(basic.password, created: user.passwordHash) else { return nil }
                return user
            }
    }
}
