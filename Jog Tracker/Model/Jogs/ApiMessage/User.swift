//
//  User.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

struct User: Codable {
    var id: String
    var email: String
    var first_name: String
    var last_name: String
}
