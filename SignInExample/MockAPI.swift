//
//  MockAPI.swift
//  SignInExample
//
//  Created by Ian Terrell on 6/6/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation
import ReSwift

struct MockAPI: SignInService {
    static let users = [
        "mark@facebook.com": (password: "dadada", data: User(name: "Mark", token: "fb123")),
        ]

    enum Error: ServiceError {
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

    final class CancelToken: Cancelable {
        var completion: (Result<User,ServiceError>->())?
        var canceled = false

        init(completion: Result<User,ServiceError>->()) {
            self.completion = completion
        }
        func cancel() {
            canceled = true
        }

        func completion(result: Result<User,ServiceError>) {
            if !canceled {
                completion?(result)
            }
            completion = nil
        }
    }

    func signIn(email email: String, password: String, completion: Result<User,ServiceError>->()) -> Cancelable {
        let cancelable = CancelToken(completion: completion)

        let constantResponseTime: Int64 = 100
        let variableResponseTime = Int64(arc4random_uniform(1400))
        let responseTime = dispatch_time(DISPATCH_TIME_NOW, (constantResponseTime + variableResponseTime) * Int64(NSEC_PER_MSEC))
        dispatch_after(responseTime, dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
            guard password != "500error" else {
                cancelable.completion(.error(Error.serverError))
                return
            }

            guard let user = MockAPI.users[email] else {
                cancelable.completion(.error(Error.noSuchUser))
                return
            }

            guard user.password == password else {
                cancelable.completion(.error(Error.invalidPassword))
                return
            }

            cancelable.completion(.success(user.data))
        }

        return cancelable
    }

    func signOut() {
        // make believe
    }
}
