//
//  SignInNimbleTests.swift
//  SignInExample
//
//  Created by Philip Sawyer on 6/22/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation
import UIKit
import FBSnapshotTestCase

@testable import SignInExample

class SignInSnapshotTests: FBSnapshotTestCase {

    static var controller: SignInViewController!
    static var window: UIWindow!

    var state = AppState()

    var validFormState: AppState {
        var state = AppState()
        state.signInForm.email = "mark@facebook.com"
        state.signInForm.emailEditedOnce = true
        state.signInForm.password = "password"
        state.signInForm.passwordEditedOnce = true
        return state
    }

    override class func setUp() {
        super.setUp()

        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SignInViewController") as! SignInViewController
        controller.inject(api: MockAPI())

        UIApplication.sharedApplication().keyWindow?.rootViewController = UINavigationController(rootViewController: controller)
        controller.loadViewIfNeeded()
        window = UIApplication.sharedApplication().keyWindow
    }

    override func setUp() {
        super.setUp()
        recordMode = false
        state = AppState()
    }

    override func tearDown() {
        SignInSnapshotTests.controller.newState(state)
        FBSnapshotVerifyView(SignInSnapshotTests.window)
    }

    func testInvalidEmail() {
        state.signInForm.email = "mark@facebook"
        state.signInForm.emailEditedOnce = true
    }

    func testValidEmail() {
        state.signInForm.email = "mark@facebook.com"
        state.signInForm.emailEditedOnce = true
    }

    func testInvalidPassword() {
        state.signInForm.password = "pas"
        state.signInForm.passwordEditedOnce = true
    }

    func testValidPassword() {
        state.signInForm.password = "password"
        state.signInForm.passwordEditedOnce = true
    }

    func testInvalidEmailAndPassword() {
        state.signInForm.email = "mark@facebook"
        state.signInForm.emailEditedOnce = true
        state.signInForm.password = "pas"
        state.signInForm.passwordEditedOnce = true
    }

    func testValidEmailAndPassword() {
        state = validFormState
    }

    func testErrorNoSuchUser() {
        state = validFormState
        state.signInForm.serverError = MockAPI.Error.noSuchUser.message
    }

    func testErrorInvalidPassword() {
        state = validFormState
        state.signInForm.serverError = MockAPI.Error.invalidPassword.message
    }

    func testErrorServerError() {
        state = validFormState
        state.signInForm.serverError = MockAPI.Error.serverError.message
    }

    func testSigningIn() {
        state = validFormState
        state.signInForm.isSigningIn = true
    }

}