//
//  Reducers.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/15/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation
import ReSwift

struct AppReducer: Reducer {
    func handleAction(action: Action, state: AppState?) -> AppState {
        let state = state ?? AppState()
        return AppState(
            user: userReducer(action, state: state),
            signInForm: signInReducer(action, state: state.signInForm)
        )
    }
}

func userReducer(action: Action, state: AppState) -> User? {
    guard let action = action as? AuthenticationAction else {
        return state.user
    }

    switch action {
    case .signIn(let user):
        return user
    case .signOut:
        return nil
    }
}

func signInReducer(action: Action, state: SignInState) -> SignInState {
    guard let action = action as? SignInFormAction else {
        return state
    }

    var state = state
    switch action {
    case .reset:
        state.password = nil
        state.passwordEditedOnce = false
        state.serverError = nil
        if (state.email ?? "").isEmpty {
            state.emailEditedOnce = false
        }
    case .requested:
        state.isSigningIn = true
    case .success:
        state.isSigningIn = false
    case .error(let error):
        state.isSigningIn = false
        state.serverError = error.message
    case .emailEdited:
        state.emailEditedOnce = true
    case .emailUpdated(let email):
        state.email = email
    case .passwordEdited:
        state.passwordEditedOnce = true
    case .passwordUpdated(let password):
        state.password = password
    }

    return state
}
