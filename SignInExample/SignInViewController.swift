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

    var viewModel: ViewModel!

    func inject(api api: SignInService) {
        viewModel = ViewModel(api: api)
    }

    override func viewDidLoad() {
        viewModel.serverError.bindTo(serverErrorLabel.bnd_text)
        viewModel.serverError.map{ $0 == nil }.bindTo(serverErrorView.bnd_hidden)

        viewModel.email.bidirectionalBindTo(emailField.bnd_text)
        viewModel.hideEmailError.bindTo(emailErrorLabel.bnd_hidden)

        viewModel.password.bidirectionalBindTo(passwordField.bnd_text)
        viewModel.hidePasswordError.bindTo(passwordErrorLabel.bnd_hidden)

        viewModel.isFormValid.bindTo(signInButton.bnd_enabled)

        viewModel.isSigningIn.bindTo(signInButton.bnd_hidden)
        viewModel.isSigningIn.map{ !$0 }.bindTo(activityIndicator.bnd_hidden)
    }

    @IBAction func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func signIn() {
        guard viewModel.isFormValid.value else {
            return
        }

        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()

        viewModel.signIn { [weak self] success in
            if success {
                self?.dismiss()
            }
        }
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
            viewModel.emailEditedOnce.value = true
        case passwordField:
            viewModel.passwordEditedOnce.value = true
        default:
            break
        }
    }
}
