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
    
    let jogs = Jogs.shared
    
    private let cellIdentifier = "customCell"
    private let cellNibName = "CustomTableViewCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Your jogs"
        
        jogs.delegate = self
        
        tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        let authentication = AuthenticationWithUUID.shared
        if authentication.isAuthorized {
            jogs.loadFromAPI()
        } else {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(successAuthentication(param:)),
                                                   name: .AuthenticationPassed,
                                                   object: nil)
            present(AuthenticationViewController(), animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(newJog))
        
        self.clearsSelectionOnViewWillAppear = true
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe))
        swipe.delegate = self
        swipe.direction = .right
        view.addGestureRecognizer(swipe)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jogs.jogsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
        for: indexPath) as! CustomTableViewCell
        let jog = jogs.jogsList[indexPath.row]
        cell.configurateCell(distance: jog.distance, times: jog.time, date: jog.date)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jogViewController = JogViewController(newJog: jogs.jogsList[indexPath.row])
        navigationController?.pushViewController(jogViewController, animated: true)
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

extension JogsTableViewController: JogsDelegate {
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

extension JogsTableViewController: UIGestureRecognizerDelegate {
    
}
