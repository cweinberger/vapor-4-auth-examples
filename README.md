# Basic Authenticator example

This example shows how to implement Basic authentication yourself. It is based on the vapor-4 api template.

## Features

- all `Todo` related endpoints are basic auth protected
- you can create new users as well as fetching single or all users
- I have added `PublicUser` to outline that you should not use database entities in your APIs (for reasons such as decoupling or control over data you want to expost)

## Added files

- `UserAuthenticator.swift`: Implements basic auth for our User, checking if the `username` matches our `email` and the `password` matches our `passwordHash`
- `UserController.swift`: Provides routes to create/get users.
- `User.swift`: Our user model; conforms to `Authenticatable`

## Modified files

- `routes.swift`: Added a protected route for  `Todo` related endpoints; `UserAuthenticator` checks if we have an authenticated user (and returns it or `nil`). `GuardMiddleware` ensures that you can only pass if a user has been added to the requests (by `UserAuthenticator().middleware()`) 
