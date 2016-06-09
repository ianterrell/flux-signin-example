//
//  HomeViewModel.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/9/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation
import Bond

final class HomeViewModel: NSObject {
    static let defaultGreeting = "Hello!"

    let api: SignInService!

    let user = EventProducer<User?>()
    let greeting = Observable<String>(HomeViewModel.defaultGreeting)

    init(api: SignInService) {
        self.api = api
        user.map { HomeViewModel.greeting($0) }.bindTo(greeting)

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
}

extension HomeViewModel {
    func signedIn(notification: NSNotification) {
        guard let box = notification.object as? Box<User> else {
            preconditionFailure("Notification should only be sent with a Box<User>")
        }
        user.next(box.contents)
    }

    func signedOut() {
        user.next(nil)
    }
}

extension Selector {
    static let signedIn = #selector(HomeViewModel.signedIn(_:))
    static let signedOut = #selector(HomeViewModel.signedOut)
}