//
//  CancelableTests.swift
//  SignInExample
//
//  Created by Ian Terrell on 7/6/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation
import XCTest
@testable import SignInExample

final class CancelOwner {
    static var alive = 0

    var success = false
    var error = ""
    var canceled = false

    var request: CancelableFuture<Bool,String>?
    init() {
        CancelOwner.alive += 1
    }
    deinit {
        CancelOwner.alive -= 1
    }
    func create() -> CancelableFuture<Bool,String> {
        let r = CancelableFuture<Bool,String>()
        r.onSuccess { [weak self] s in
            self?.success = s
        }
        r.onError { [weak self] e in
            self?.error = e
        }
        r.onCancel { [weak self] in
            self?.canceled = true
        }
        self.request = r
        return r
    }
}

class CancelableTests: XCTestCase {

    override func setUp() {
        CancelOwner.alive = 0
    }

    func testCycle() {
        var co: CancelOwner? = CancelOwner()
        co?.create()
        XCTAssertEqual(1, CancelOwner.alive)
        co = nil
        XCTAssertEqual(0, CancelOwner.alive)
    }

    func testFire() {
        let co = CancelOwner()
        let request = co.create()
        XCTAssertEqual(false, co.success)
        request.fill(.success(true))

        let expectation = expectationWithDescription("Check fire")
        dispatch_async(dispatch_get_main_queue()) {
            XCTAssertEqual(true, co.success)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testCancel() {
        let co = CancelOwner()
        let request = co.create()
        XCTAssertEqual(false, co.success)
        XCTAssertEqual(false, co.canceled)
        request.cancel()

        let expectation = expectationWithDescription("Check fire")
        dispatch_async(dispatch_get_main_queue()) {
            XCTAssertEqual(false, co.success)
            XCTAssertEqual(true, co.canceled)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1, handler: nil)
    }
}
