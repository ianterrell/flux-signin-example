//
//  HomeViewController.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/6/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var signInButton: UIBarButtonItem!
    @IBOutlet var signOutButton: UIBarButtonItem!

    @IBOutlet var helloLabel: UILabel!

    var user: User? {
        didSet {
            updateMessage()
        }
    }

    var api: SignInService!

    override func viewDidLoad() {
        User.addObserver(self, selector: .signedIn, notification: .signedIn)
        User.addObserver(self, selector: .signedOut, notification: .signedOut)
        updateMessage()
    }

    deinit {
        User.notificationCenter.removeObserver(self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let signIn: SignInViewController = segue.destinationViewController.injectable() {
            signIn.api = api
        }
    }

    @IBAction func signOut(sender: AnyObject) {
        api.signOut()
    }

    func updateMessage() {
        helloLabel?.text = greetingMessage
    }

    var greetingMessage: String {
        guard let user = user else {
            return "Hello!"
        }

        return "Hello, \(user.name)!"
    }
}


extension HomeViewController {
    func signedIn(notification: NSNotification) {
        guard let box = notification.object as? Box<User> else {
            preconditionFailure("Notification should only be sent with a Box<User>")
        }
        navigationItem.rightBarButtonItem = signOutButton
        user = box.contents
    }

    func signedOut() {
        navigationItem.rightBarButtonItem = signInButton
        user = nil
    }
}

extension Selector {
    static let signedIn = #selector(HomeViewController.signedIn(_:))
    static let signedOut = #selector(HomeViewController.signedOut)
}
