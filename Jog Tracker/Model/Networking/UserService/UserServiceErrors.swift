//
//  UserServiceErrors.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/12/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

enum UserServiceErrors: Error {
    case noAuthentication
    case urlError
}
