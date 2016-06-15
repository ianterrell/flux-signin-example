//
//  SignInViewModel.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/9/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation
import Bond

extension SignInViewController {
    final class ViewModel: NSObject {
        let api: SignInService!

        let serverError = Observable<String?>(nil)

        let email = Observable<String?>(nil)
        let emailEditedOnce = Observable(false)

        let password = Observable<String?>(nil)
        let passwordEditedOnce = Observable(false)

        let isEmailValid: EventProducer<Bool>
        let isPasswordValid: EventProducer<Bool>
        let isFormValid = Observable<Bool>(false)

        let hideEmailError: EventProducer<Bool>
        let hidePasswordError: EventProducer<Bool>

        let isSigningIn = EventProducer<Bool>()

        init(api: SignInService) {
            self.api = api

            isEmailValid = email.map { Validation.isValidEmail($0 ?? "") }
            hideEmailError = combineLatest(emailEditedOnce, isEmailValid).map { !$0 || $1 }

            isPasswordValid = password.map { Validation.isValidPassword($0 ?? "") }
            hidePasswordError = combineLatest(passwordEditedOnce, isPasswordValid).map { !$0 || $1 }

            combineLatest(isEmailValid, isPasswordValid).map { $0 && $1 }.bindTo(isFormValid)

            super.init()
        }

        func signIn(completion: (success: Bool)->()) {
            guard let email = email.value, let password = password.value else {
                return
            }

            serverError.value = nil
            isSigningIn.next(true)

            api.signIn(email: email, password: password) { [weak self] result in
                guard let sself = self else {
                    return
                }

                dispatch_async(dispatch_get_main_queue()) {
                    sself.isSigningIn.next(false)

                    switch result {
                    case .success(_):
                        completion(success: true)
                        break
                    case .error(let e):
                        sself.serverError.value = e.message
                        completion(success: false)
                    }
                }
            }
        }

    }
}
