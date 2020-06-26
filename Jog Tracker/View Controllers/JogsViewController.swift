//
//  JogsTableViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class JogsViewController: UIViewController {
    
    let jogs = Jogs.shared
    
    //MARK: NavigationBar
    var navigationBarView: UIView!
    var logoImageView: UIImageView!
    var menuButton: UIButton!
    var filterButton: UIButton!
    
    var tableView: UITableView!
    var addNewJogButton: UIButton!
        
    private let cellIdentifier = "customCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarView = UIView()
        logoImageView = UIImageView()
        menuButton = UIButton()
        menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        filterButton = UIButton()
        filterButton.addTarget(self, action: #selector(presentWeaklyReport), for: .touchUpInside)
        addNewJogButton = UIButton()
        addNewJogButton.addTarget(self, action: #selector(newJog), for: .touchUpInside)
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 190
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        jogs.delegate = self
        
        let authentication = AuthenticationWithUUID.shared
        if authentication.isAuthorized {
            jogs.loadFromAPI()
        } else {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(successAuthentication(param:)),
                                                   name: .AuthenticationPassed,
                                                   object: nil)
            let authenticationViewController = AuthenticationViewController()
            authenticationViewController.modalPresentationStyle = .fullScreen
            present(authenticationViewController, animated: true)
        }
    
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //MARK: TableView Settings
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 77, left: 0, bottom: 0, right: 0))
        }
        
        //MARK: NavigationBarView Settings
        
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints {
            $0.width.equalTo(375)
            $0.height.equalTo(77)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalTo(view.snp.centerX)
        }
        navigationBarView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        //MARK: LogoImageView Settings
        
        navigationBarView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.top).offset(20)
            $0.left.equalTo(navigationBarView.snp.left).offset(25)
            $0.height.equalTo(37)
            $0.width.equalTo(98)
        }
        logoImageView.image = UIImage(named: ImageName.logoImageName)
        
        //MARK: FilterButton Settings
        
        navigationBarView.addSubview(filterButton)
        filterButton.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.top).offset(26)
            $0.left.equalTo(navigationBarView.snp.left).offset(251)
            $0.height.equalTo(26)
            $0.width.equalTo(26)
        }
        filterButton.setImage(UIImage(named: ImageName.filterImageName), for: .normal)
        
        //MARK: MenuButton Settings
        
        navigationBarView.addSubview(menuButton)
        menuButton.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.top).offset(27)
            $0.left.equalTo(navigationBarView.snp.left).offset(322)
            $0.height.equalTo(24)
            $0.width.equalTo(28)
        }
        menuButton.setImage(UIImage(named: ImageName.menuImageName), for: .normal)
        
        //MARK: AddNewJogButton Settings
        
        view.addSubview(addNewJogButton)
        addNewJogButton.snp.makeConstraints {
            $0.height.equalTo(47)
            $0.width.equalTo(47)
            $0.right.equalTo(view.snp.right).offset(-30)
            $0.bottom.equalTo(view.snp.bottom).offset(-30)
        }
        addNewJogButton.setImage(UIImage(named: ImageName.addJogImageName), for: .normal)
    }

    @objc func newJog() {
        let jogViewController = JogViewController()
        navigationController?.pushViewController(jogViewController, animated: true)
    }
    
    @objc func successAuthentication(param: Notification) {
        jogs.loadFromAPI()
    }
    
    @objc func openMenu() {
        let menuViewController =  MenuViewController()
        menuViewController.modalPresentationStyle = .fullScreen
        menuViewController.currentNavigationController = navigationController
        present(menuViewController, animated: true)
    }
    
    @objc func presentWeaklyReport() {
        let weeklyReportViewController = WeeklyReportViewController()
        navigationController?.pushViewController(weeklyReportViewController, animated: false)
    }
    
    private func alertConfiguration(with error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default)
        alert.addAction(okAction)
        present(alert,
                animated: true)
    }
}

extension JogsViewController: JogsDelegate {
    func updatingDataDidFinished() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updatingDataDidFinished(with error: Error) {
        switch error {
        case JogsServiceErrors.noAuthentication:
            let authenticationViewController = AuthenticationViewController()
            present(authenticationViewController, animated: true)
        default:
            DispatchQueue.main.async {
                self.alertConfiguration(with: error)
            }
        }
    }
}

extension JogsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jogs.jogsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
        for: indexPath) as! CustomTableViewCell
        let jog = jogs.jogsList[indexPath.row]
        cell.configurateCell(distance: jog.distance, time: jog.time, date: jog.date)
        return cell
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let jogViewController = JogViewController(newJog: jogs.jogsList[indexPath.row])
        navigationController?.pushViewController(jogViewController, animated: true)
        return false
    }
}
