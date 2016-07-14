//
//  ActionCreators.swift
//  SignInExample
//
//  Created by Ian Terrell on 7/5/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation
import ReSwift

final class AuthenticationActionCreator {
    let api: SignInService
    let store: Store<AppState>

    init(store: Store<AppState>, api: SignInService) {
        self.api = api
        self.store = store
    }

    func signIn(email email: String, password: String) -> CancelableFuture<User,ServiceError> {
        store.dispatch(SignInFormAction.requested)
        let future = CancelableFuture<User,ServiceError>()
        let cancelToken = api.signIn(email: email, password: password) { [weak self] result in
            guard let store = self?.store else {
                return
            }

            dispatch_async(dispatch_get_main_queue()) {
                switch result {
                case .success(let user):
                    store.dispatch(SignInFormAction.success)
                    store.dispatch(AuthenticationAction.signIn(user))
                case .error(let error):
                    store.dispatch(SignInFormAction.error(error))
                }
                future.fill(result)
            }
        }

        future.onCancel {
            cancelToken.cancel()
        }
        
        return future
    }
}