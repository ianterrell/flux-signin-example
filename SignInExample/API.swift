//
//  API.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/6/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation

struct User {
    let name: String
    let token: String
}

protocol SignInAPIError: ErrorType {
    var message: String { get }
}

enum Result<S,E> {
    case success(S)
    case error(E)
}

protocol SignInAPI {
    func signIn(email email: String, password: String, completion: Result<User,SignInAPIError>->())
}

