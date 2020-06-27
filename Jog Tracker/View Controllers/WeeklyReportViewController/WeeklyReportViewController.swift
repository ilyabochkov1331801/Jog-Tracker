//
//  WeeklyReportTableViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class WeeklyReportViewController: UIViewController {
        
    private let cellIdentifier = "customCell"
    private let fromDateLabelText = "Date from"
    private let toDateLabelText = "Date to"
    
    private var weeklyReports = WeeklyReports.shared
    private var tableView: UITableView!
    
    //MARK: NavigationBar
    var navigationBarView: UIView!
    var logoImageView: UIImageView!
    var menuButton: UIButton!
    var filterButton: UIButton!
    
    var filterSettingsView: UIView!
    var fromDateTextFiled: UITextField!
    var fromDateLabel: UILabel!
    var toDateTextFiled: UITextField!
    var toDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        navigationBarView = UIView()
        logoImageView = UIImageView()
        menuButton = UIButton()
        menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        filterButton = UIButton()
        filterButton.addTarget(self, action: #selector(closeWeaklyReport), for: .touchUpInside)
        filterSettingsView = UIView()
        fromDateTextFiled = UITextField()
        fromDateLabel = UILabel()
        toDateTextFiled = UITextField()
        toDateTextFiled.delegate = self
        fromDateTextFiled.delegate = self
        toDateLabel = UILabel()

        tableView.register(WeeklyReportTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.weeklyReports.set(newReportFilter: ReportFilter(), completionHandler: completionHandler)
        tableView.rowHeight = 190
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //MARK: TableView Settings
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 137, left: 0, bottom: 0, right: 0))
        }
        
        //MARK: NavigationBarView Settings
        
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints {
            $0.width.equalTo(view.snp.width)
            $0.height.equalTo(77)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalTo(view.snp.centerX)
        }
        navigationBarView.backgroundColor = Colors.appGreen
        
        //MARK: LogoImageView Settings
        
        navigationBarView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.edges.equalTo(navigationBarView).inset(UIEdgeInsets(top: 20, left: 25, bottom: 20, right: 252))
        }
        logoImageView.image = UIImage(named: ImageName.logoImageName)
        
        //MARK: FilterButton Settings
        
        navigationBarView.addSubview(filterButton)
        filterButton.snp.makeConstraints {
            $0.edges.equalTo(navigationBarView).inset(UIEdgeInsets(top: 26, left: 251, bottom: 25, right: 98))
        }
        filterButton.setImage(UIImage(named: ImageName.filterSelectImageName), for: .normal)
        
        //MARK: MenuButton Settings
        
        navigationBarView.addSubview(menuButton)
        menuButton.snp.makeConstraints {
            $0.edges.equalTo(navigationBarView).inset(UIEdgeInsets(top: 27, left: 322, bottom: 26, right: 25))
        }
        menuButton.setImage(UIImage(named: ImageName.menuImageName), for: .normal)
        
        //MARK: FilterSettings Settings
        
        view.addSubview(filterSettingsView)
        filterSettingsView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(375)
            $0.height.equalTo(60)
        }
        filterSettingsView.backgroundColor = Colors.appGray
        
        //MARK: FromDateTextFiled and FromDateLabel Settings
        
        filterSettingsView.addSubview(fromDateTextFiled)
        fromDateTextFiled.snp.makeConstraints {
            $0.edges.equalTo(filterSettingsView).inset(UIEdgeInsets(top: 16, left: 106, bottom: 13, right: 190))
        }
        fromDateTextFiled.borderStyle = .roundedRect

        filterSettingsView.addSubview(fromDateLabel)
        fromDateLabel.snp.makeConstraints {
            $0.centerY.equalTo(fromDateTextFiled)
            $0.right.equalTo(fromDateTextFiled.snp.left).offset(-16)
        }
        fromDateLabel.font = Fonts.weeklyReportVCLabelFont
        fromDateLabel.text = fromDateLabelText
        fromDateLabel.textColor = .gray
        
        //MARK: ToDateTextFiled and ToDateLabel Settings
        
        filterSettingsView.addSubview(toDateTextFiled)
        toDateTextFiled.snp.makeConstraints {
            $0.edges.equalTo(filterSettingsView).inset(UIEdgeInsets(top: 16, left: 267, bottom: 13, right: 29))
        }
        toDateTextFiled.borderStyle = .roundedRect

        filterSettingsView.addSubview(toDateLabel)
        toDateLabel.snp.makeConstraints { 
            $0.centerY.equalTo(toDateTextFiled)
            $0.right.equalTo(toDateTextFiled.snp.left).offset(-16)
        }
        toDateLabel.font = Fonts.weeklyReportVCLabelFont
        toDateLabel.text = toDateLabelText
        toDateLabel.textColor = .gray
    }
    
    @objc func openMenu() {
        let menuViewController =  MenuViewController()
        menuViewController.modalPresentationStyle = .fullScreen
        menuViewController.currentNavigationController = navigationController
        present(menuViewController, animated: true)
    }
    
    @objc func closeWeaklyReport() {
        navigationController?.popViewController(animated: false)
    }
    
    private lazy var completionHandler: () -> () = {
        self.tableView.reloadData()
        self.toDateTextFiled.text = DateFormatters.weeklyReportVCDateFormatter.string(from: self.weeklyReports.reportFilter.toDate)
        self.fromDateTextFiled.text = DateFormatters.weeklyReportVCDateFormatter.string(from: self.weeklyReports.reportFilter.fromDate)
    }
}

extension WeeklyReportViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyReports.weaklyReportsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
        for: indexPath) as! WeeklyReportTableViewCell
        let weeklyReport = weeklyReports.weaklyReportsList[indexPath.row]
        cell.configurateCell(distance: weeklyReport.allDistance,
                             time: weeklyReport.allTime,
                             fromDate: weeklyReport.beginOfWeek,
                             toDate: weeklyReport.endOfWeek)
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension WeeklyReportViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let fromDateString = fromDateTextFiled.text,
            let fromDate = DateFormatters.weeklyReportVCDateFormatter.date(from: fromDateString),
            let toDateString = toDateTextFiled.text,
            let toDate = DateFormatters.weeklyReportVCDateFormatter.date(from: toDateString) else {
                return
        }
        let weeklyReportFilter = ReportFilter(fromDate: fromDate, toDate: toDate)
        weeklyReports.set(newReportFilter: weeklyReportFilter, completionHandler: completionHandler)
    }
}
