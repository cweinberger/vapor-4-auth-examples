import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    app.get("hello") { req in
        return "Hello, world!"
    }

    let userProtectedRoutes = app
        .grouped(User.guardMiddleware()
    )

    let todoController = TodoController()
    userProtectedRoutes.get("todos", use: todoController.index)
    userProtectedRoutes.post("todos", use: todoController.create)
    userProtectedRoutes.on(.DELETE, "todos", ":todoID", use: todoController.delete)

    let userController = UserController()
    try app.register(collection: userController)
}
