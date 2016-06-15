//
//  HomeViewController.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/6/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import UIKit
import ReSwift

class HomeViewController: UIViewController, StoreSubscriber {
    @IBOutlet var signInButton: UIBarButtonItem!
    @IBOutlet var signOutButton: UIBarButtonItem!

    @IBOutlet var helloLabel: UILabel!

    var api: SignInService!

    func inject(api api: SignInService) {
        self.api = api
    }

    override func viewWillAppear(animated: Bool) {
        mainStore.subscribe(self)
    }

    override func viewWillDisappear(animated: Bool) {
        mainStore.unsubscribe(self)
    }

    func newState(state: AppState) {
        let viewState = ViewState(user: state.user)
        helloLabel.text = viewState.greeting
        updateAuthenticationStatus(viewState.signedIn)
    }

    func updateAuthenticationStatus(signedIn: Bool) {
        navigationItem.rightBarButtonItem = signedIn ? signOutButton : signInButton
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let signIn: SignInViewController = segue.destinationViewController.injectable() {
            signIn.inject(api: api)
        }
    }

    @IBAction func signOut(sender: AnyObject) {
        api.signOut()
    }
}

extension HomeViewController {
    struct ViewState {
        let signedIn: Bool
        let greeting: String

        init(user: User?) {
            signedIn = user != nil
            if let user = user {
                greeting = "Hello, \(user.name)!"
            } else {
                greeting = "Hello!"
            }
        }
    }
}
