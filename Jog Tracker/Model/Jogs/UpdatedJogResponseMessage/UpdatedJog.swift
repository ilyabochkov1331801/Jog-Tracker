//
//  UpdatedJog.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/24/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

struct UpdatedJogResponse: Codable {
    let id: Int
    let userId: Int
    let distance: Double
    let time: Int
    let date: String
}
