//
//  SignInNimbleTests.swift
//  SignInExample
//
//  Created by Philip Sawyer on 6/22/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation
import Nimble
import Quick
import Nimble_Snapshots
import UIKit

@testable import SignInExample

class SignInNimbleTests: QuickSpec {
    
    var signInController: SignInViewController!
    
    override func setUp() {
        super.setUp()
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SignInViewController") as! SignInViewController
        controller.inject(api: MockAPI())
        signInController = controller
        UIApplication.sharedApplication().keyWindow?.rootViewController = signInController
    }
    
    override func spec() {
        describe("SignInViewController", { () -> () in
            it("has invalid email") {
                
                
                mainStore.dispatch(SignInFormAction.emailUpdated("mark@facebook"))
                mainStore.dispatch(SignInFormAction.emailEdited)
                
                let window = UIApplication.sharedApplication().keyWindow
                expect(window).to( recordSnapshot())
                
                mainStore.dispatch(SignInFormAction.emailUpdated(""))
            }
        });
        
        describe("SignInViewController", { () -> () in
            it("has valid email") {
                
                
                mainStore.dispatch(SignInFormAction.emailUpdated("mark@facebook.com"))
                mainStore.dispatch(SignInFormAction.emailEdited)
                
                let window = UIApplication.sharedApplication().keyWindow
                expect(window).to( recordSnapshot())
                
                mainStore.dispatch(SignInFormAction.emailUpdated(""))
            }
        });
        
        describe("SignInViewController", { () -> () in
            it("has invalid password") {
                
                mainStore.dispatch(SignInFormAction.passwordUpdated("pas"))
                mainStore.dispatch(SignInFormAction.passwordEdited)
                
                let window = UIApplication.sharedApplication().keyWindow
                expect(window).to( recordSnapshot())
            }
        });
        
        describe("SignInViewController", { () -> () in
            it("has valid password") {
                
                mainStore.dispatch(SignInFormAction.passwordUpdated("password"))
                mainStore.dispatch(SignInFormAction.passwordEdited)
                
                let window = UIApplication.sharedApplication().keyWindow
                expect(window).to( recordSnapshot())
            }
        });
        
        describe("SignInViewController", { () -> () in
            it("has invalid email and password") {
                
                
                mainStore.dispatch(SignInFormAction.emailUpdated("mark@facebook"))
                mainStore.dispatch(SignInFormAction.emailEdited)
                mainStore.dispatch(SignInFormAction.passwordUpdated("pas"))
                mainStore.dispatch(SignInFormAction.passwordEdited)
                
                let window = UIApplication.sharedApplication().keyWindow
                expect(window).to( recordSnapshot())
            }
        });
        
        describe("SignInViewController", { () -> () in
            it("has valid email and password") {
                
                
                mainStore.dispatch(SignInFormAction.emailUpdated("mark@facebook.com"))
                mainStore.dispatch(SignInFormAction.emailEdited)
                mainStore.dispatch(SignInFormAction.passwordUpdated("password"))
                mainStore.dispatch(SignInFormAction.passwordEdited)
                
                let window = UIApplication.sharedApplication().keyWindow
                expect(window).to( recordSnapshot())
            }
        });
        
        describe("SignInViewController", { () -> () in
            it("has error no such user") {
                
                
                mainStore.dispatch(SignInFormAction.emailUpdated("mark@facebook.com"))
                mainStore.dispatch(SignInFormAction.emailEdited)
                mainStore.dispatch(SignInFormAction.passwordUpdated("password"))
                mainStore.dispatch(SignInFormAction.passwordEdited)
                
                let error = MockAPI.Error.noSuchUser
                mainStore.dispatch(SignInFormAction.error(error))
                
                let window = UIApplication.sharedApplication().keyWindow
                expect(window).to( recordSnapshot())
            }
        });
        
        describe("SignInViewController", { () -> () in
            it("has error invalid password") {
                
                
                mainStore.dispatch(SignInFormAction.emailUpdated("mark@facebook.com"))
                mainStore.dispatch(SignInFormAction.emailEdited)
                mainStore.dispatch(SignInFormAction.passwordUpdated("password"))
                mainStore.dispatch(SignInFormAction.passwordEdited)
                
                let error = MockAPI.Error.invalidPassword
                mainStore.dispatch(SignInFormAction.error(error))
                
                let window = UIApplication.sharedApplication().keyWindow
                expect(window).to( recordSnapshot())
            }
        });
        
        describe("SignInViewController", { () -> () in
            it("has error server error") {
                
                
                mainStore.dispatch(SignInFormAction.emailUpdated("mark@facebook.com"))
                mainStore.dispatch(SignInFormAction.emailEdited)
                mainStore.dispatch(SignInFormAction.passwordUpdated("password"))
                mainStore.dispatch(SignInFormAction.passwordEdited)
                
                let error = MockAPI.Error.serverError
                mainStore.dispatch(SignInFormAction.error(error))
                
                let window = UIApplication.sharedApplication().keyWindow
                expect(window).to( recordSnapshot())
            }
        });
    }
}