//
//  WeeklyReport .swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class WeeklyReports {
    
    private let jogs = Jogs.shared
    private let weekTimeInterval = Int(TimeInterval(60 * 60 * 24 * 7))
    
    private(set) var weaklyReportsList: Array<WeaklyReport> = []
    
    func calculateWeaklyReportsList() {
        let jogsList = jogs.jogsList
        var weeks: Dictionary<Int, Array<Jog>> = [:]
        let now = Int(Date().timeIntervalSince1970)
        for jog in jogsList {
            let weekNumber = Int((now - jog.date) / weekTimeInterval)
            if weeks[weekNumber] != nil {
                weeks[weekNumber]!.append(jog)
            } else {
                weeks[weekNumber] = [ jog ]
            }
        }
        for weekNumber in weeks.keys {
            if let weekJogs = weeks[weekNumber] {
                var allDistance: Double = 0.0
                var allTime: Int = 0
                for jog in weekJogs {
                    allDistance += jog.distance
                    allTime += jog.time
                }
                let weaklyReport = WeaklyReport(numberOfWeek: weekNumber,
                                                beginOfWeek: Date(timeIntervalSince1970: TimeInterval(now - (weekNumber + 1) * weekTimeInterval)),
                                                endOfWeek: Date(timeIntervalSince1970: TimeInterval(now - weekNumber * weekTimeInterval)),
                                                avaregeSpeed: (allDistance * 1000) / (Double(allTime) * 60),
                                                allTime: allTime,
                                                allDistance: allDistance)
                weaklyReportsList.append(weaklyReport)
            }
            weaklyReportsList.sort {
                $0.numberOfWeek < $1.numberOfWeek
            }
        }
    }
}
