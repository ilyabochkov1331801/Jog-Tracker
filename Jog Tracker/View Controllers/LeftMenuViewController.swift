//
//  LeftMenuViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func sendFeedbackButtonTapped(_ sender: UIButton) {
        present(SendFeedbackViewController(), animated: true)
    }
}
