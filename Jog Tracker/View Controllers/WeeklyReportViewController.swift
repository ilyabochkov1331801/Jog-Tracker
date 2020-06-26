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
    private let labelsFont = UIFont(name: "SFUIText-Regular", size: 10)
    
    private var weeklyReports = WeeklyReports()
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
        tableView.register(WeeklyReportTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.weeklyReports.calculateWeaklyReportsList()
        tableView.rowHeight = 190
        
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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reportFilterSettingsDidChange),
                                               name: .ReportFilterSettingsChanged,
                                               object: nil)
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //MARK: TableView Settings
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 137, left: 0, bottom: 0, right: 0))
        }
        
        //MARK: NavigationBarView Settings
        
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints {
            (make) in
            make.width.equalTo(view.snp.width)
            make.height.size.equalTo(77)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalTo(view.snp.centerX)
        }
        navigationBarView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        //MARK: LogoImageView Settings
        
        navigationBarView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            (make) in
            make.edges.equalTo(navigationBarView).inset(UIEdgeInsets(top: 20, left: 25, bottom: 20, right: 252))
        }
        logoImageView.image = UIImage(named: ImageName.logoImageName)
        
        //MARK: FilterButton Settings
        
        navigationBarView.addSubview(filterButton)
        filterButton.snp.makeConstraints {
            (make) in
            make.edges.equalTo(navigationBarView).inset(UIEdgeInsets(top: 26, left: 251, bottom: 25, right: 98))
        }
        filterButton.setImage(UIImage(named: ImageName.filterSelectImageName), for: .normal)
        
        //MARK: MenuButton Settings
        
        navigationBarView.addSubview(menuButton)
        menuButton.snp.makeConstraints {
            (make) in
            make.edges.equalTo(navigationBarView).inset(UIEdgeInsets(top: 27, left: 322, bottom: 26, right: 25))
        }
        menuButton.setImage(UIImage(named: ImageName.menuImageName), for: .normal)
        
        //MARK: FilterSettings Settings
        
        view.addSubview(filterSettingsView)
        filterSettingsView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBarView.snp.bottom)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(375)
            make.height.equalTo(60)
        }
        filterSettingsView.backgroundColor = .lightGray
        
        //MARK: FromDateTextFiled and FromDateLabel Settings
        
        filterSettingsView.addSubview(fromDateTextFiled)
        fromDateTextFiled.snp.makeConstraints { (make) in
            make.edges.equalTo(filterSettingsView).inset(UIEdgeInsets(top: 16, left: 111, bottom: 13, right: 193))
        }
        fromDateTextFiled.borderStyle = .roundedRect

        filterSettingsView.addSubview(fromDateLabel)
        fromDateLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(filterSettingsView).inset(UIEdgeInsets(top: 24, left: 19, bottom: 21, right: 280))
        }
        fromDateLabel.font = labelsFont
        fromDateLabel.text = fromDateLabelText
        
        //MARK: ToDateTextFiled and ToDateLabel Settings
        
        filterSettingsView.addSubview(toDateTextFiled)
        toDateTextFiled.snp.makeConstraints { (make) in
            make.edges.equalTo(filterSettingsView).inset(UIEdgeInsets(top: 16, left: 284, bottom: 13, right: 19))
        }
        toDateTextFiled.borderStyle = .roundedRect

        filterSettingsView.addSubview(toDateLabel)
        toDateLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(filterSettingsView).inset(UIEdgeInsets(top: 24, left: 210, bottom: 21, right: 107))
        }
        toDateLabel.font = labelsFont
        toDateLabel.text = toDateLabelText
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
    
    @objc func reportFilterSettingsDidChange() {
        self.weeklyReports.calculateWeaklyReportsList()
        tableView.reloadData()
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
}
