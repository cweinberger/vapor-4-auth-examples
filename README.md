# Basic Authenticator example

This example shows how to implement Basic authentication yourself. It is based on the vapor-4 api template.

By using `UserAuthenticator().middleware()` as a global middleware (added in `configure.swift`), we will try to fetch a user for all requests.
I have added two ways of protecting routes:
a) using a protectedRoute with a `GuardMiddleware()` for Todo-related endpoints (see `routes.swift`)
b) using `req.auth.has(User.self)` in `UserController.swift` to protect single endpoints (as we dont want to protect the register user endpoint).

## Principles

- `UserAuthenticator().middleware()`  try to fetch a user for any given request and attach the fetched user to the request object
- `GuardMiddleware()` simply checks if a `Authenticatable` model is attached to the request and throws if not.

## Added files

- `UserAuthenticator.swift`: Implements basic auth for our User, checking if the `username` matches our `email` and the `password` matches our `passwordHash`
- `UserController.swift`: Provides routes to create/get users.
- `User.swift`: Our user model; conforms to `Authenticatable`

## Modified files

- `routes.swift`: Added a protected route for  `Todo` related endpoints using `GuardMiddleware`.
- `configure.swift`: Added the `UserAuthenticator().middleware()` to the global middlewares.
