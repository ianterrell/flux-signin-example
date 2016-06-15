//
//  HomeViewModel.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/9/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation
import Bond

extension HomeViewController {
    final class ViewModel: NSObject {
        static let defaultGreeting = "Hello!"

        let api: SignInService!

        let user = Observable<User?>(nil)
        let greeting = Observable(ViewModel.defaultGreeting)

        init(api: SignInService) {
            self.api = api
            user.map { ViewModel.greeting($0) }.bindTo(greeting)

            super.init()

            User.addObserver(self, selector: .signedIn, notification: .signedIn)
            User.addObserver(self, selector: .signedOut, notification: .signedOut)
        }

        static func greeting(user: User?) -> String {
            guard let user = user else {
                return "Hello!"
            }
            return "Hello, \(user.name)!"
        }

        deinit {
            User.notificationCenter.removeObserver(self)
        }

        func signOut() {
            api.signOut()
        }

        func signedIn(notification: NSNotification) {
            guard let box = notification.object as? Box<User> else {
                preconditionFailure("Notification should only be sent with a Box<User>")
            }
            user.value = box.contents
        }
        
        func signedOut() {
            user.value = nil
        }
    }
}

private extension Selector {
    static let signedIn = #selector(HomeViewController.ViewModel.signedIn(_:))
    static let signedOut = #selector(HomeViewController.ViewModel.signedOut)
}
