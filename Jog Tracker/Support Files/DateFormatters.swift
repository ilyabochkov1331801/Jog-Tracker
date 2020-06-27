//
//  DateFormatters.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/27/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

enum DateFormatters {
    static var cellDateFromatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
    
    static var jogVCDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }
    
    static var weeklyReportVCDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }
    
    static var jogsApiDateManagerDateFormatter: ISO8601DateFormatter {
        let newDateFormatter = ISO8601DateFormatter()
        newDateFormatter.formatOptions = [.withFullDate,
                                   .withTime,
                                   .withDashSeparatorInDate,
                                   .withColonSeparatorInTime]
        return newDateFormatter
    }
}
