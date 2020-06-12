//
//  LeftMenuViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController {

    private let controllerTitle = "Actions"
    
    @IBOutlet weak var weeklyReportButton: UIButton! {
        didSet {
            weeklyReportButton.layer.cornerRadius = weeklyReportButton.bounds.height / 2
        }
    }
    
    @IBOutlet weak var sendFeedbackButton: UIButton! {
        didSet {
            sendFeedbackButton.layer.cornerRadius = sendFeedbackButton.bounds.height / 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = controllerTitle
    }

    @IBAction func sendFeedbackButtonTapped(_ sender: UIButton) {
        present(SendFeedbackViewController(), animated: true)
    }
    @IBAction func weeklyReportBottonTupped(_ sender: UIButton) {
        navigationController?.pushViewController(WeeklyReportTableViewController(), animated: true)
    }
}
