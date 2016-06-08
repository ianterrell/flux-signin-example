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

// MARK: - Notifier

// Modified from the original at
// https://medium.com/swift-programming/swift-nsnotificationcenter-protocol-c527e67d93a1#.lbec25dxh

public protocol Notifier {
    associatedtype Notification: RawRepresentable

    static var notificationCenter: NSNotificationCenter { get }
}

public extension Notifier where Notification.RawValue == String {

    static var notificationCenter: NSNotificationCenter {
        return NSNotificationCenter.defaultCenter()
    }

    private static func nameFor(notification: Notification) -> String {
        return "\(self).\(notification.rawValue)"
    }

    func postNotification(notification: Notification, object: AnyObject? = nil) {
        Self.postNotification(notification, object: object)
    }

    func postNotification(notification: Notification, object: AnyObject? = nil, userInfo: [String : AnyObject]? = nil) {
        Self.postNotification(notification, object: object, userInfo: userInfo)
    }

    static func postNotification(notification: Notification, object: AnyObject? = nil, userInfo: [String : AnyObject]? = nil) {
        let name = nameFor(notification)

        Self.notificationCenter.postNotificationName(name, object: object, userInfo: userInfo)
    }

    static func addObserver(observer: AnyObject, selector: Selector, notification: Notification) {
        let name = nameFor(notification)

        Self.notificationCenter.addObserver(observer, selector: selector, name: name, object: nil)
    }

    static func removeObserver(observer: AnyObject, notification: Notification, object: AnyObject? = nil) {
        let name = nameFor(notification)

        Self.notificationCenter.removeObserver(observer, name: name, object: object)
    }
}
