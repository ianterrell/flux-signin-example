//
//  SignInViewController.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/6/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet var serverErrorView: UIView!
    @IBOutlet var serverErrorLabel: UILabel!

    @IBOutlet var emailField: UITextField!
    @IBOutlet var emailErrorLabel: UILabel!

    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordErrorLabel: UILabel!

    @IBOutlet var signInButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    var api: SignInService!

    var emailEditedOnce = false
    var passwordEditedOnce = false

    @IBAction func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func signIn() {
        let (_, _, formIsValid) = isValid()
        guard formIsValid,
              let email = emailField.text,
              let password = passwordField.text
        else {
            return
        }

        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()

        signInButton.hidden = true
        activityIndicator.hidden = false
        serverErrorView.hidden = true

        api.signIn(email: email, password: password) { [weak self] result in
            guard let sself = self else {
                return
            }

            dispatch_async(dispatch_get_main_queue()) {
                sself.activityIndicator.hidden = true
                switch result {
                case .success(_):
                    sself.dismiss()
                case .error(let e):
                    sself.signInButton.hidden = false
                    sself.serverErrorLabel.text = e.message
                    sself.serverErrorView.hidden = false
                }
            }
        }
    }
}

// MARK: - Lifecycle Methods

extension SignInViewController {
    override func viewDidLoad() {
        emailField.addTarget(self, action: .validate, forControlEvents: .EditingChanged)
        passwordField.addTarget(self, action: .validate, forControlEvents: .EditingChanged)

        serverErrorView.hidden = true
        emailErrorLabel.hidden = true
        passwordErrorLabel.hidden = true
    }
}

// MARK: - Validation

extension SignInViewController {
    func validate() {
        let (emailIsValid, passwordIsValid, formIsValid) = isValid()
        emailErrorLabel.hidden = !emailEditedOnce || emailIsValid
        passwordErrorLabel.hidden = !passwordEditedOnce || passwordIsValid
        signInButton.enabled = formIsValid
    }

    func isValid() -> (email: Bool, password: Bool, form: Bool) {
        let email = Validation.isValidEmail(emailField.text ?? "")
        let password = Validation.isValidPassword(passwordField.text ?? "")
        let form = email && password
        return (email: email, password: password, form: form)
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
            emailEditedOnce = true
        case passwordField:
            passwordEditedOnce = true
        default:
            break
        }

        validate()
    }
}

private extension Selector {
    static let validate = #selector(SignInViewController.validate)
}
