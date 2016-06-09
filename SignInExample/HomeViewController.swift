//
//  HomeViewController.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/6/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import UIKit
import Bond

class HomeViewController: UIViewController {
    @IBOutlet var signInButton: UIBarButtonItem!
    @IBOutlet var signOutButton: UIBarButtonItem!

    @IBOutlet var helloLabel: UILabel!

    var api: SignInService!
    var viewModel: HomeViewModel!

    func inject(api api: SignInService) {
        self.api = api
        viewModel = HomeViewModel(api: api)
    }

    override func viewDidLoad() {
        viewModel.greeting.bindTo(helloLabel.bnd_text)
        viewModel.user.map{$0 != nil}.observe { [unowned self] in self.updateAuthenticationStatus($0) }
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
        viewModel.signOut()
    }
}
