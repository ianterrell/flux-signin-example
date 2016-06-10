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
}

struct HomeState {
    var signedIn = false
    var greeting = "Hello!"
}

enum AuthenticationAction: Action {
    case signIn(User)
    case signOut
}

struct AppReducer: Reducer {
    func handleAction(action: Action, state: AppState?) -> AppState {
        let state = state ?? AppState()
        return AppState(
            homeScreen: homeReducer(action, state: state.homeScreen)
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
