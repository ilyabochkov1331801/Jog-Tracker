//
//  WeeklyReportTableViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class WeeklyReportTableViewController: UITableViewController {
        
    private let cellIdentifier = "customCell"
    private let cellNibName = "WeeklyReportTableViewCell"
    
    private var weeklyReports = WeeklyReports()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        DispatchQueue.global(qos: .userInteractive).async {
            self.weeklyReports.calculateWeaklyReportsList()
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 100
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(openReportFilterSettings))
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reportFilterSettingsDidChange),
                                               name: .ReportFilterSettingsChanged,
                                               object: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyReports.weaklyReportsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
        for: indexPath) as! WeeklyReportTableViewCell
        cell.configurateCell(weaklyReport: weeklyReports.weaklyReportsList[indexPath.row])
        return cell
    }
    
    @objc func openReportFilterSettings() {
        present(ReportFilterSettingsViewController(), animated: true)
    }
    
    @objc func reportFilterSettingsDidChange() {
        self.weeklyReports.calculateWeaklyReportsList()
        tableView.reloadData()
    }
}
