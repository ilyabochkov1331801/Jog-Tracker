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
    private let reportFilterSettings = ReportFilterSettings.shared
    
    func calculateWeaklyReportsList() {
        DispatchQueue.global(qos: .userInteractive).async {
            self.weaklyReportsList = []
            let jogsList = self.jogs.jogsList
            var weeks: Dictionary<Int, Array<Jog>> = [:]
            let now = Int(Date().timeIntervalSince1970)
            for jog in jogsList {
                let date = Date(timeIntervalSince1970: TimeInterval(jog.date))
                if date.compare(self.reportFilterSettings.reportFilter.fromDate) == .orderedAscending || date.compare(self.reportFilterSettings.reportFilter.toDate) == .orderedDescending {
                    continue
                }
                let weekNumber = Int((now - jog.date) / self.weekTimeInterval)
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
                                                    beginOfWeek: Date(timeIntervalSince1970: TimeInterval(now - (weekNumber + 1) * self.weekTimeInterval)),
                                                    endOfWeek: Date(timeIntervalSince1970: TimeInterval(now - weekNumber * self.weekTimeInterval)),
                                                    avaregeSpeed: (allDistance * 1000) / (Double(allTime) * 60),
                                                    allTime: allTime,
                                                    allDistance: allDistance)
                    self.weaklyReportsList.append(weaklyReport)
                }
            }
            self.weaklyReportsList.sort {
                $0.numberOfWeek < $1.numberOfWeek
            }
        }
    }
}
