//
//  WeaklyReport.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

struct WeeklyReport {
    let numberOfWeek: Int
    var beginOfWeek: Date
    var endOfWeek: Date
    
    let avaregeSpeed: Double
    let allTime: Int
    let allDistance: Double
}
