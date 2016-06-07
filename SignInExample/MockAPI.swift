//
//  MockAPI.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/6/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation

struct MockAPI: SignInAPI {
    static let users = [
        "mark@facebook.com": (password: "dadada", data: User(name: "Mark", token: "fb123")),
        ]

    enum Error: SignInAPIError {
        case noSuchUser
        case invalidPassword
        case serverError

        var message: String {
            switch self {
            case noSuchUser: return "We could not find that user in our system."
            case invalidPassword: return "Your password was invalid."
            case serverError: return "We're experiencing downtime. Please try again later."
            }
        }
    }

    func signIn(email email: String, password: String, completion: Result<User,SignInAPIError>->()) {
        let constantResponseTime: Int64 = 100
        let variableResponseTime = Int64(arc4random_uniform(1400))
        let responseTime = dispatch_time(DISPATCH_TIME_NOW, (constantResponseTime + variableResponseTime) * Int64(NSEC_PER_MSEC))
        dispatch_after(responseTime, dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
            guard password != "500error" else {
                completion(.error(Error.serverError))
                return
            }

            guard let user = MockAPI.users[email] else {
                completion(.error(Error.noSuchUser))
                return
            }

            guard user.password == password else {
                completion(.error(Error.invalidPassword))
                return
            }

            completion(.success(user.data))
        }
    }
}

