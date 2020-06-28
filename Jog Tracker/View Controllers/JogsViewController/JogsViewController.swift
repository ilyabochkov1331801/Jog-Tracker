//
//  JogsTableViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class JogsViewController: UIViewController {
    
    private let jogsService = JogsService.shared
    private var jogsList: Array<Jog> = []
    
    private let cellIdentifier = "JogTableViewCell"
    
    private var navigationBarView: UIView!
    private var logoImageView: UIImageView!
    private var menuButton: UIButton!
    private var filterButton: UIButton!
    private var tableView: UITableView!
    private var addNewJogButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarView = UIView()
        logoImageView = UIImageView()
        menuButton = UIButton()
        filterButton = UIButton()
        addNewJogButton = UIButton()
        
        addNewJogButton.addTarget(self, action: #selector(newJog), for: .touchUpInside)
        menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(presentWeaklyReport), for: .touchUpInside)
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 190
        tableView.register(JogTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        let authenticationService = AuthenticationService.shared
        if authenticationService.isAuthorized {
            jogsService.getJogs { [weak self] (result) in
                self?.updateData()
            }
        } else {
            let authenticationViewController = AuthenticationViewController()
            authenticationViewController.modalPresentationStyle = .fullScreen
            present(authenticationViewController, animated: true)
        }
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
            $0.width.equalTo(view.snp.width)
            $0.height.equalTo(77)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalTo(view.snp.centerX)
        }
        navigationBarView.backgroundColor = Colors.appGreen
        
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

    @objc private func newJog() {
        let jogViewController = JogViewController()
        jogViewController.delegate = self
        navigationController?.pushViewController(jogViewController, animated: true)
    }
    
    @objc private func openMenu() {
        let menuViewController =  MenuViewController()
        menuViewController.modalPresentationStyle = .fullScreen
        menuViewController.currentNavigationController = navigationController
        present(menuViewController, animated: true)
    }
    
    @objc private func presentWeaklyReport() {
        navigationController?.viewControllers = [ WeeklyReportViewController() ]
    }
}

extension JogsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jogsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
        for: indexPath) as! JogTableViewCell
        let jog = jogsList[indexPath.row]
        cell.configurateCell(distance: jog.distance, time: jog.time, date: jog.date)
        return cell
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let jogViewController = JogViewController(newJog: jogsList[indexPath.row])
        jogViewController.delegate = self
        navigationController?.pushViewController(jogViewController, animated: true)
        return false
    }
}

extension JogsViewController: JogViewControllerDelegate {
    func updateData() {
        jogsService.getJogs {
            [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let newJogsList):
                self.jogsList = newJogsList
                self.tableView.reloadData()
            case .failure(let error):
                self.alertConfiguration(with: error)
            }
        }
    }
}
