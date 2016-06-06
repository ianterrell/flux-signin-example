//
//  Extensions.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/6/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import UIKit

extension UIViewController {
    func injectable<T>() -> T? {
        var controller: UIViewController? = self
        if let nav = self as? UINavigationController {
            controller = nav.viewControllers.first
        }
        return controller as? T
    }
}