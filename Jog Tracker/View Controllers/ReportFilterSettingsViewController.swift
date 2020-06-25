//
//  ReportSettingsViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/10/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class ReportFilterSettingsViewController: UIViewController {

    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    
    private let weeklyReports = WeeklyReports.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromDatePicker.date = weeklyReports.reportFilter.fromDate
        toDatePicker.date = weeklyReports.reportFilter.toDate
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        weeklyReports.reportFilter = ReportFilter(fromDate: fromDatePicker.date, toDate: toDatePicker.date)
        super.viewWillDisappear(animated)
    }
}
