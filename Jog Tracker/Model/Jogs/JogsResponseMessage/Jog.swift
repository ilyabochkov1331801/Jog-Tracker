//
//  Jog.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

struct Jog: Codable {
    let id: Int
    let userId: String
    let distance: Double
    let time: Int
    let date: TimeInterval
}

