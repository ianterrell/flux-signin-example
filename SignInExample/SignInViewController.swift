//
//  SignInViewController.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/6/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import UIKit
import ReSwift

class SignInViewController: UIViewController, StoreSubscriber {
    @IBOutlet var serverErrorView: UIView!
    @IBOutlet var serverErrorLabel: UILabel!

    @IBOutlet var emailField: UITextField!
    @IBOutlet var emailErrorLabel: UILabel!

    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordErrorLabel: UILabel!

    @IBOutlet var signInButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    var api: SignInService!
    var state: SignInState!

    func inject(api api: SignInService) {
        self.api = api
    }

    override func viewWillAppear(animated: Bool) {
        mainStore.subscribe(self)
    }

    override func viewWillDisappear(animated: Bool) {
        mainStore.dispatch(SignInFormAction.reset)
        mainStore.unsubscribe(self)
    }

    override func viewDidLoad() {
        emailField.addTarget(self, action: .emailUpdated, forControlEvents: .EditingChanged)
        passwordField.addTarget(self, action: .passwordUpdated, forControlEvents: .EditingChanged)
    }

    func newState(appState: AppState) {
        state = appState.signInForm
        let viewState = ViewState(state: state)

        serverErrorLabel.text = state.serverError
        serverErrorView.hidden = viewState.hideServerError

        emailField.text = state.email
        emailField.enabled = !state.isSigningIn
        emailErrorLabel.hidden = viewState.hideEmailError

        passwordField.text = state.password
        passwordField.enabled = !state.isSigningIn
        passwordErrorLabel.hidden = viewState.hidePasswordError

        signInButton.enabled = state.isFormValid
        signInButton.hidden = state.isSigningIn
        activityIndicator.hidden = !state.isSigningIn
    }

    @IBAction func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func signIn() {
        guard state.isFormValid,
              let email = state.email,
              let password = state.password
        else {
            return
        }

        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()

        mainStore.dispatch(SignInFormAction.requested)
        api.signIn(email: email, password: password) { [weak self] result in
            guard let sself = self else {
                return
            }

            dispatch_async(dispatch_get_main_queue()) {
                switch result {
                case .success(let user):
                    mainStore.dispatch(SignInFormAction.success)
                    mainStore.dispatch(AuthenticationAction.signIn(user))
                    sself.dismiss()
                    break
                case .error(let error):
                    mainStore.dispatch(SignInFormAction.error(error))
                }
            }
        }
    }
}

// MARK: - View State

extension SignInViewController {
    struct ViewState {
        let hideServerError: Bool
        let hideEmailError: Bool
        let hidePasswordError: Bool

        init(state: SignInState) {
            hideServerError = state.serverError == nil
            hideEmailError = !state.emailEditedOnce || state.isEmailValid
            hidePasswordError = !state.passwordEditedOnce || state.isPasswordValid
        }
    }
}

// MARK: - Editing Events

extension SignInViewController {
    func emailUpdated() {
        mainStore.dispatch(SignInFormAction.emailUpdated(emailField.text ?? ""))
    }

    func passwordUpdated() {
        mainStore.dispatch(SignInFormAction.passwordUpdated(passwordField.text ?? ""))
    }
}

// MARK: - UITextFieldDelegate

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case emailField:
            passwordField.becomeFirstResponder()
        case passwordField:
            signIn()
        default:
            break
        }

        return true
    }

    func textFieldDidEndEditing(textField: UITextField) {
        switch textField {
        case emailField:
            mainStore.dispatch(SignInFormAction.emailEdited)
        case passwordField:
            mainStore.dispatch(SignInFormAction.passwordEdited)
        default:
            break
        }
    }
}

private extension Selector {
    static let emailUpdated = #selector(SignInViewController.emailUpdated)
    static let passwordUpdated = #selector(SignInViewController.passwordUpdated)
}
