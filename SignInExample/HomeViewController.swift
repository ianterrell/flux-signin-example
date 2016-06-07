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

    var api: SignInAPI!

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let signIn: SignInViewController = segue.destinationViewController.injectable() {
            signIn.api = api
        }
    }

    @IBAction func signOut(sender: AnyObject) {

    }
}
