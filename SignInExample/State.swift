//
//  State.swift
//  SignInExamplev
//
//  Created by Ian Terrell on 6/10/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation
import ReSwift

let mainStore = Store<AppState>(reducer: AppReducer(), state: nil, middleware: [AuthenticationSaga(api: MockAPI()).middleware])

struct AppState: StateType {
    var user: User?
    var signInForm = SignInState()
}

struct SignInState {
    var isSigningIn = false
    var serverError: String?

    var email: String?
    var emailEditedOnce = false

    var password: String?
    var passwordEditedOnce = false
}

extension SignInState {
    var isEmailValid: Bool {
        return Validation.isValidEmail(email ?? "")
    }

    var isPasswordValid: Bool {
        return Validation.isValidPassword(password ?? "")
    }

    var isFormValid: Bool {
        return isEmailValid && isPasswordValid
    }
}

