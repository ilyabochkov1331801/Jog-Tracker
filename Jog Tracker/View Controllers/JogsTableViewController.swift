//
//  JogsTableViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit
import SideMenu

class JogsTableViewController: UITableViewController {
    
    let jogs = JogsService.shared
    var jogsList: Array<Jog> = []
    
    private let controllerTitle = "Your jogs"
    private let cellIdentifier = "customCell"
    private let cellNibName = "CustomTableViewCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = controllerTitle
                
        tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        let authentication = AuthenticationService.shared
        if authentication.isAuthorized {
            updateData()
        } else {
            let authenticationViewController = AuthenticationViewController()
            authenticationViewController.modalPresentationStyle = .fullScreen
            present(authenticationViewController, animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(newJog))
        
        self.clearsSelectionOnViewWillAppear = true
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe))
        swipe.delegate = self
        swipe.direction = .right
        view.addGestureRecognizer(swipe)
        
        tableView.rowHeight = 60

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jogsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
        for: indexPath) as! CustomTableViewCell
        let jog = jogsList[indexPath.row]
        cell.configurateCell(distance: jog.distance, times: jog.time, date: jog.date)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jogViewController = JogViewController(newJog: jogsList[indexPath.row])
        jogViewController.delegate = self
        navigationController?.pushViewController(jogViewController, animated: true)
    }
    
    @objc func newJog() {
        let jogViewController = JogViewController()
        jogViewController.delegate = self
        navigationController?.pushViewController(jogViewController, animated: true)
    }
    
    @objc func leftSwipe() {
        let leftMenu = SideMenuNavigationController(rootViewController: LeftMenuViewController())
        leftMenu.presentationStyle = .menuSlideIn
        leftMenu.leftSide = true
        leftMenu.menuWidth = 300
        present(leftMenu, animated: true)
    }
}


extension JogsTableViewController: UIGestureRecognizerDelegate {
    
}

extension JogsTableViewController: JogViewControllerDelegate {
    func updateData() {
        jogs.getJogs {
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
