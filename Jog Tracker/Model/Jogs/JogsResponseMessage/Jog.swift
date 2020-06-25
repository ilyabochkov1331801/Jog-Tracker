//
//  Jog.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

struct Jog: Codable {
    var id: Int
    var userId: String
    var distance: Double
    var time: Int
    var date: TimeInterval
}

