//
//  State.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/10/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation
import ReSwift

let mainStore = Store<AppState>(reducer: AppReducer(), state: nil)

struct AppState: StateType {
    var homeScreen = HomeState()
    var signInScreen = SignInState()
}

struct HomeState {
    var signedIn = false
    var greeting = "Hello!"
}

struct SignInState {
    var serverError: String?

    var email: String?
    var emailEditedOnce = false

    var password: String?
    var passwordEditedOnce = false

    var isEmailValid = true
    var isPasswordValid = true
    var isFormValid = false

    var isSigningIn = false
}

enum AuthenticationAction: Action {
    case signIn(User)
    case signOut
}

enum SignInFormAction: Action {
    case signInRequest
    case signInSuccess
    case signInError(ServiceError)

    case emailEdited
    case emailUpdated(String)

    case passwordEdited
    case passwordUpdated(String)
}

struct AppReducer: Reducer {
    func handleAction(action: Action, state: AppState?) -> AppState {
        let state = state ?? AppState()
        return AppState(
            homeScreen: homeReducer(action, state: state.homeScreen),
            signInScreen: signInReducer(action, state: state.signInScreen)
        )
    }
}

func homeReducer(action: Action, state: HomeState) -> HomeState {
    guard let action = action as? AuthenticationAction else {
        return state
    }

    var state = state
    switch action {
    case .signIn(let user):
        state.signedIn = true
        state.greeting = "Hello, \(user.name)!"
    case .signOut:
        state.signedIn = false
        state.greeting = "Hello!"
    }
    return state
}

func signInReducer(action: Action, state: SignInState) -> SignInState {
    guard let action = action as? SignInFormAction else {
        return state
    }

    var state = state
    switch action {
    case .signInRequest:
        state.isSigningIn = true
    case .signInSuccess:
        state.isSigningIn = false
    case .signInError(let error):
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

    state.isEmailValid = !state.emailEditedOnce || Validation.isValidEmail(state.email ?? "")
    state.isPasswordValid = !state.passwordEditedOnce || Validation.isValidPassword(state.password ?? "")
    state.isFormValid = state.emailEditedOnce && state.isEmailValid &&
        state.passwordEditedOnce && state.isPasswordValid

    return state
}
