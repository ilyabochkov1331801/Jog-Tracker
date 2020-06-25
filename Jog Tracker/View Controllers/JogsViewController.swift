//
//  JogsTableViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit
import SideMenu

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
    private let logoImageName = "logoImage"
    private let filterImageName = "filterImage"
    private let menuImageName = "menuImage"
    private let addJogImageName = "addJogImage"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarView = UIView()
        logoImageView = UIImageView()
        menuButton = UIButton()
        menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        filterButton = UIButton()
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
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe))
        swipe.delegate = self
        swipe.direction = .right
        view.addGestureRecognizer(swipe)
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //MARK: TableView Settings
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            (make) in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: 77, left: 0, bottom: 0, right: 0))
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
        logoImageView.image = UIImage(named: logoImageName)
        
        //MARK: FilterButton Settings
        
        navigationBarView.addSubview(filterButton)
        filterButton.snp.makeConstraints {
            (make) in
            make.edges.equalTo(navigationBarView).inset(UIEdgeInsets(top: 26, left: 251, bottom: 25, right: 98))
        }
        filterButton.setImage(UIImage(named: filterImageName), for: .normal)
        
        //MARK: MenuButton Settings
        
        navigationBarView.addSubview(menuButton)
        menuButton.snp.makeConstraints {
            (make) in
            make.edges.equalTo(navigationBarView).inset(UIEdgeInsets(top: 27, left: 322, bottom: 26, right: 25))
        }
        menuButton.setImage(UIImage(named: menuImageName), for: .normal)
        
        //MARK: AddNewJogButton Settings
        
        view.addSubview(addNewJogButton)
        addNewJogButton.snp.makeConstraints {
            (make) in
            make.height.size.equalTo(47)
            make.width.size.equalTo(47)
            make.right.equalTo(view.snp.right).offset(-30)
            make.bottom.equalTo(view.snp.bottom).offset(-30)
        }
        addNewJogButton.setImage(UIImage(named: addJogImageName), for: .normal)
    }

    @objc func newJog() {
        let jogViewController = JogViewController()
        navigationController?.pushViewController(jogViewController, animated: true)
    }
    
    @objc func successAuthentication(param: Notification) {
        jogs.loadFromAPI()
    }
    
    @objc func leftSwipe() {
        let leftMenu = SideMenuNavigationController(rootViewController: LeftMenuViewController())
        leftMenu.presentationStyle = .menuSlideIn
        leftMenu.leftSide = true
        leftMenu.menuWidth = 300
        present(leftMenu, animated: true)
    }
    
    @objc func openMenu() {
        let menuViewController = MenuViewController()
        menuViewController.modalPresentationStyle = .fullScreen
        present(MenuViewController(), animated: true)
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

extension JogsViewController: UIGestureRecognizerDelegate {
    
}

extension JogsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(jogs.jogsList.count)
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
