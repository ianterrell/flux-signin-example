//
//  Middleware.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/30/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation
import ReSwift

final class AuthenticationSaga {
    let api: SignInService

    init(api: SignInService) {
        self.api = api
    }

    func middleware(dispatch: DispatchFunction?, getState: GetState?) -> (DispatchFunction -> DispatchFunction) {
        return { next in
            return { [api = self.api] action in
                if case let SignInFormAction.request(email, password) = action {
                    api.signIn(email: email, password: password) { result in
                        dispatch_async(dispatch_get_main_queue()) {
                            switch result {
                            case .success(let user):
                                dispatch?(SignInFormAction.success)
                                dispatch?(AuthenticationAction.signIn(user))
                                break
                            case .error(let error):
                                dispatch?(SignInFormAction.error(error))
                            }
                        }
                    }
                }

                if case AuthenticationAction.signOut = action {
                    api.signOut()
                }

                return next(action)
            }
        }
    }
}
