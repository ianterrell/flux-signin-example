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

    var store: Store<AppState>!
    var api: SignInService!

    func inject(store store: Store<AppState>, api: SignInService) {
        self.store = store
        self.api = api
    }

    override func viewWillAppear(animated: Bool) {
        store.subscribe(self)
    }

    override func viewWillDisappear(animated: Bool) {
        store.unsubscribe(self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let signIn: SignInViewController = segue.destinationViewController.injectable() {
            signIn.inject(store: store, api: api)
        }
    }

    func newState(state: AppState) {
        let viewState = ViewState(user: state.user)
        helloLabel.text = viewState.greeting
        updateAuthenticationStatus(viewState.signedIn)
    }

    func updateAuthenticationStatus(signedIn: Bool) {
        navigationItem.rightBarButtonItem = signedIn ? signOutButton : signInButton
    }

    @IBAction func signOut(sender: AnyObject) {
        store.dispatch(AuthenticationAction.signOut)
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
