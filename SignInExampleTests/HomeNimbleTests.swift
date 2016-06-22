//
//  HomeNimbleTests.swift
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

class HomePageNimbleTests: QuickSpec {
    
    var homeController: HomeViewController!
    
    override func setUp() {
        super.setUp()
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        controller.inject(api: MockAPI())
        homeController = controller
        UIApplication.sharedApplication().keyWindow?.rootViewController = homeController
    }
    
    override func spec() {
        super.spec()
        
        describe("HomeViewController", { () -> () in
            it("has no user") {
                let window = UIApplication.sharedApplication().keyWindow
                expect(window).to(haveValidSnapshot())
            }
        });
        
        
        describe("HomeViewController", { () -> () in
            it("has valid user") {
                mainStore.dispatch(SignInFormAction.success)
                let user = User(name: "Mark", token: "fb123")
                mainStore.dispatch(AuthenticationAction.signIn(user))
                
                let window = UIApplication.sharedApplication().keyWindow
                expect(window).to(haveValidSnapshot())
            }
        });
    }
}