//
//  Validation.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/7/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation

struct Validation {
    static let emailRegex = try! NSRegularExpression(
        pattern:"^(?:[^.@]+[.][^.@]+|[^.@]+)+[@](?:[^.@]+[.][^.@]+|[^.@]+)+[.][^.@]+$",
        options: .CaseInsensitive)

    static func isValidEmail(email: String) -> Bool {
        let match = emailRegex.firstMatchInString(email, options: [], range: NSMakeRange(0, email.characters.count))
        return match != nil
    }

    static func isValidPassword(password: String) -> Bool {
        return password.characters.count > 3
    }
}
