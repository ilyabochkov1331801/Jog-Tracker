//
//  Response.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

struct Response: Codable {
    var jogs: Array<Jog>
    var users: Array<User>
}
