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

    var store: Store<AppState>!
    var api: SignInService!
    var authentication: AuthenticationActionCreator!

    var state: SignInState!
    var signInRequest: CancelableFuture<User, ServiceError>?

    func inject(store store: Store<AppState>, api: SignInService) {
        self.store = store
        self.api = api
        self.authentication = AuthenticationActionCreator(store: store, api: api)
    }

    override func viewWillAppear(animated: Bool) {
        store.subscribe(self) { $0.signInForm }
    }

    override func viewWillDisappear(animated: Bool) {
        store.dispatch(SignInFormAction.reset)
        store.unsubscribe(self)
        signInRequest?.cancel()
    }

    override func viewDidLoad() {
        emailField.addTarget(self, action: .emailUpdated, forControlEvents: .EditingChanged)
        passwordField.addTarget(self, action: .passwordUpdated, forControlEvents: .EditingChanged)
    }

    func newState(state: SignInState) {
        self.state = state
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

        signInRequest = authentication.signIn(email: email, password: password)
        signInRequest?.onSuccess { [weak self] _ in
            self?.dismiss()
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
        store.dispatch(SignInFormAction.emailUpdated(emailField.text ?? ""))
    }

    func passwordUpdated() {
        store.dispatch(SignInFormAction.passwordUpdated(passwordField.text ?? ""))
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
            store.dispatch(SignInFormAction.emailEdited)
        case passwordField:
            store.dispatch(SignInFormAction.passwordEdited)
        default:
            break
        }
    }
}

private extension Selector {
    static let emailUpdated = #selector(SignInViewController.emailUpdated)
    static let passwordUpdated = #selector(SignInViewController.passwordUpdated)
}
