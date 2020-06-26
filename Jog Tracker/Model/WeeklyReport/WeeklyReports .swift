//
//  WeeklyReport .swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class WeeklyReports {
    
    static let shared = WeeklyReports()
    private init() { }
    
    var jogsList: Array<Jog> = []
    private(set) var weaklyReportsList: Array<WeaklyReport> = []
    private let jogs = JogsService.shared
    private let weekTimeInterval = TimeInterval(60 * 60 * 24 * 7)
    private var mondayDate: TimeInterval {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!.timeIntervalSince1970 + weekTimeInterval
    }
    
    var reportFilter = ReportFilter()
    
    func set(newReportFilter: ReportFilter, completionHandler: @escaping () -> ()) {
        self.reportFilter = newReportFilter
        DispatchQueue.global(qos: .userInitiated).async {
            self.calculateWeaklyReportsList(completionHandler: completionHandler)
        }
    }
    
    private func calculateWeaklyReportsList(completionHandler: @escaping () -> ()) {
        self.weaklyReportsList.removeAll()
        
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
            if date.compare(reportFilter.fromDate) == .orderedAscending || date.compare(reportFilter.toDate) == .orderedDescending {
                continue
            }
            let weekNumber = Int((mondayDate - jog.date) / weekTimeInterval)
            if weeks[weekNumber] != nil {
                weeks[weekNumber]!.append(jog)
            } else {
                weeks[weekNumber] = [ jog ]
            }
        }
        weaklyReportsList = weeks.map { (key, value) -> WeaklyReport in
            var allDistance: Double = 0.0
            var allTime: Int = 0
            for jog in value {
                allDistance += jog.distance
                allTime += jog.time
            }
            let weaklyReport = WeaklyReport(numberOfWeek: key,
                                            beginOfWeek: Date(timeIntervalSince1970: TimeInterval(mondayDate - Double((key + 1)) * weekTimeInterval)),
                                                endOfWeek: Date(timeIntervalSince1970: TimeInterval(mondayDate - Double(key) * weekTimeInterval)),
                                            avaregeSpeed: (allDistance * 1000) / (Double(allTime) * 60),
                                            allTime: allTime,
                                            allDistance: allDistance)
            return weaklyReport
        }

        self.weaklyReportsList.sort {
            $0.numberOfWeek < $1.numberOfWeek
        }
        weaklyReportsList[0].endOfWeek = reportFilter.toDate
        weaklyReportsList[weaklyReportsList.count - 1].beginOfWeek = reportFilter.fromDate
        DispatchQueue.main.async {
            completionHandler()
        }
    }
}
