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
    
    private let reportFilterSettings = ReportFilterSettings.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromDatePicker.date = reportFilterSettings.fromDate
        toDatePicker.date = reportFilterSettings.toDate
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reportFilterSettings.fromDate = fromDatePicker.date
        reportFilterSettings.toDate = toDatePicker.date
    }
}
