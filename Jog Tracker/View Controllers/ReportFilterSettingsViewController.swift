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
    var delegate: ReportFilterSettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromDatePicker.date = weeklyReports.reportFilter.fromDate
        toDatePicker.date = weeklyReports.reportFilter.toDate
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        weeklyReports.set(newReportFilter: ReportFilter(fromDate: fromDatePicker.date, toDate: toDatePicker.date)) { [weak self] in
            guard let self = self else {
                return
            }
            self.delegate?.updateReport()
        }
        super.viewWillDisappear(animated)
    }
}
