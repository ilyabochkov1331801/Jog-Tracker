//
//  JogsTableViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class JogsTableViewController: UITableViewController {
    
    let jogs = Jogs()
    private let cellIdentifier = "customCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        jogs.delegate = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        let authentication = AuthenticationWithUUID.shared
        if authentication.isAuthorized {
            jogs.loadFromAPI()
        } else {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(successAuthentication(param:)),
                                                   name: NSNotification.Name(rawValue: "authenticationPassed"),
                                                   object: nil)
            present(AuthenticationViewController(), animated: true)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jogs.jogsList.count
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
        for: indexPath) as! CustomTableViewCell
        let jog = jogs.jogsList[indexPath.row]
        cell.configurateCell(distance: jog.distance, times: jog.time, date: jog.date)
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func successAuthentication(param: Notification) {
        jogs.loadFromAPI()
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
            print(error)
        }
    }
}
