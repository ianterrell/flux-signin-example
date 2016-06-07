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

    var api: SignInAPI!
    
    @IBAction func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func signIn() {

    }
}


extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case emailField:
            passwordField.becomeFirstResponder()
        case passwordField:
            passwordField.resignFirstResponder()
            signIn()
        default:
            break
        }

        return true
    }
}