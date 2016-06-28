//
//  HomeNimbleTests.swift
//  SignInExample
//
//  Created by Philip Sawyer on 6/22/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation
import UIKit
import FBSnapshotTestCase

@testable import SignInExample

class HomeSnapshotTests: FBSnapshotTestCase {
    
    static var controller: HomeViewController!
    static var window: UIWindow!

    var state = AppState()

    override class func setUp() {
        super.setUp()

        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
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
        HomeSnapshotTests.controller.newState(state)
        FBSnapshotVerifyView(HomeSnapshotTests.window)
    }

    func testNoUser() {
        state = AppState()
    }

    func testValidUser() {
        state.user = User(name: "Mark", token: "fb123")
    }
}