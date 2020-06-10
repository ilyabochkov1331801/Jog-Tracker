//
//  ReportFilterSettings.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/10/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class ReportFilterSettings {
    
    //MARK: Singletone
    static let shared = ReportFilterSettings()
    private init() { }
    
    var fromDate: Date = Date(timeIntervalSince1970: 0) {
        didSet {
            notify()
        }
    }
    var toDate: Date = Date() {
        didSet {
            notify()
        }
    }
    
    private func notify() {
        NotificationCenter.default.post(name: .ReportFilterSettingsChanged, object: nil)
    }
}
