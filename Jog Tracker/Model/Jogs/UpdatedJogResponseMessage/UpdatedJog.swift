//
//  UpdatedJog.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/24/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

struct UpdatedJogResponse: Codable {
    var id: Int
    var userId: Int
    var distance: Double
    var time: Int
    var date: String
}
