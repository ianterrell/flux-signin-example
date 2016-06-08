//
//  API.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/6/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation

// MARK: - Model

struct User: Notifier {
    let name: String
    let token: String

    enum Notification: String {
        case signedIn
        case signedOut
    }
}

final class Box<T> {
    let contents: T

    init(contents: T) {
        self.contents = contents
    }
}

// MARK: - API

protocol ServiceError: ErrorType {
    var message: String { get }
}

protocol SignInService {
    func signIn(email email: String, password: String, completion: Result<User,ServiceError>->())
    func signOut()
}

// MARK: - Helpers

enum Result<S,E> {
    case success(S)
    case error(E)
}

