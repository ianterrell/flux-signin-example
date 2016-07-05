//
//  Cancelable.swift
//  SignInExample
//
//  Created by Ian Terrell on 7/5/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation

enum CancelableResult<S,E> {
    case start
    case canceled
    case fulfilled(Result<S,E>)
}


// This is a proof of concept. This would need tested before production use.
//
// Of especial concern is retain cycles.
final class CancelableFuture<S,E> {
    private var storage: CancelableResult<S,E> = .start
    private let onFilled = DispatchBlockMarker()

    deinit {
        cancel()
    }

    func cancel() {
        self.storage = .canceled
        onFilled.markCompleted()
    }

    func fill(result: Result<S,E>) {
        self.storage = .fulfilled(result)
        onFilled.markCompleted()
    }

    func onSuccess(body: S -> Void) {
        let block = dispatch_block_create(DISPATCH_BLOCK_ASSIGN_CURRENT) {
            guard case .fulfilled(let result) = self.storage else {
                return
            }

            switch result {
            case .success(let value):
                body(value)
            case .error(_):
                break
            }
        }
        onFilled.notify(block)
    }

    func onError(body: E -> Void) {
        let block = dispatch_block_create(DISPATCH_BLOCK_ASSIGN_CURRENT) {
            guard case .fulfilled(let result) = self.storage else {
                return
            }

            switch result {
            case .success(_):
                break
            case .error(let error):
                body(error)
            }
        }
        onFilled.notify(block)
    }

    func onCancel(body: Void -> Void) {
        let block = dispatch_block_create(DISPATCH_BLOCK_ASSIGN_CURRENT) {
            guard case .canceled = self.storage else {
                return
            }

            body()
        }
        onFilled.notify(block)
    }
}


private struct DispatchBlockMarker {
    let block = dispatch_block_create(DISPATCH_BLOCK_NO_QOS_CLASS, {
        fatalError("This code should never be executed")
    })!

    var isCompleted: Bool {
        return dispatch_block_testcancel(block) != 0
    }

    func markCompleted() {
        // Cancel it so we can use `dispatch_block_testcancel` to mean "filled"
        dispatch_block_cancel(block)
        // Executing the block "unblocks" it, calling all the `_notify` blocks
        block()
    }

    func notify(body: dispatch_block_t) {
        dispatch_block_notify(block, dispatch_get_main_queue(), body)
    }
}