//
//  Actions.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/15/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation
import ReSwift

enum AuthenticationAction: Action {
    case signIn(User)
    case signOut
}

enum SignInFormAction: Action {
    case requested
    case success
    case error(ServiceError)
    case reset

    case emailEdited
    case emailUpdated(String)

    case passwordEdited
    case passwordUpdated(String)
}
