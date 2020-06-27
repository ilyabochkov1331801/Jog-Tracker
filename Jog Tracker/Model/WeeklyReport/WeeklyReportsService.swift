//
//  WeeklyReport .swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class WeeklyReportsService {
    
    static let shared = WeeklyReportsService()
    private init() { }

    private(set) var weeklyReportsList: Array<WeeklyReport> = []
    
    private var jogsList: Array<Jog> = []
    private let jogs = JogsService.shared
    private let weekTimeInterval = TimeInterval(60 * 60 * 24 * 7)
    private(set) var weeklyReportFilter: WeeklyReportFilter!
    private var mondayDateTimeInterval: TimeInterval {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!.timeIntervalSince1970 + weekTimeInterval
    }
    
    func set(newWeeklyReportFilter: WeeklyReportFilter = WeeklyReportFilter(), completionHandler: @escaping () -> ()) {
        self.weeklyReportFilter = newWeeklyReportFilter
        DispatchQueue.global(qos: .userInitiated).async {
            self.calculateWeaklyReportsList(completionHandler: completionHandler)
        }
    }
    
    private func calculateWeaklyReportsList(completionHandler: @escaping () -> ()) {
        weeklyReportsList.removeAll()
        
        jogs.getJogs {
            [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let newJogsList):
                self.jogsList = newJogsList
            case .failure(let error):
                print(error)
            }
        }
        
        var weeks: Dictionary<Int, Array<Jog>> = [:]
        
        for jog in jogsList {
            let date = Date(timeIntervalSince1970: jog.date)
            if date.compare(weeklyReportFilter.fromDate) == .orderedAscending || date.compare(weeklyReportFilter.toDate) == .orderedDescending {
                continue
            }
            let weekNumber = Int((mondayDateTimeInterval - jog.date) / weekTimeInterval)
            if weeks[weekNumber] != nil {
                weeks[weekNumber]!.append(jog)
            } else {
                weeks[weekNumber] = [ jog ]
            }
        }
        weeklyReportsList = weeks.map { (key, value) -> WeeklyReport in
            var allDistance: Double = 0.0
            var allTime: Int = 0
            for jog in value {
                allDistance += jog.distance
                allTime += jog.time
            }
            let weaklyReport = WeeklyReport(numberOfWeek: key,
                                            beginOfWeek: Date(timeIntervalSince1970: TimeInterval(mondayDateTimeInterval - Double((key + 1)) * weekTimeInterval)),
                                                endOfWeek: Date(timeIntervalSince1970: TimeInterval(mondayDateTimeInterval - Double(key) * weekTimeInterval)),
                                            avaregeSpeed: (allDistance * 1000) / (Double(allTime) * 60),
                                            allTime: allTime,
                                            allDistance: allDistance)
            return weaklyReport
        }

        self.weeklyReportsList.sort {
            $0.numberOfWeek < $1.numberOfWeek
        }
        weeklyReportsList[0].endOfWeek = weeklyReportFilter.toDate
        weeklyReportsList[max(weeklyReportsList.count - 1, 0)].beginOfWeek = weeklyReportFilter.fromDate
        
        DispatchQueue.main.async {
            completionHandler()
        }
    }
}
