//
//  AuthenticationViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    var authentication: Authentication!
    
    @IBOutlet weak var uuidTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authentication = AuthenticationWithUUID.shared
        uuidTextField.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(successAuthentication(param:)),
                                               name: NSNotification.Name(rawValue: "authenticationPassed"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cancelAuthentication(param:)),
                                               name: NSNotification.Name(rawValue: "authenticationPassedWithError"),
                                               object: nil)
    }
    @IBAction func authorizationButtonTupped(_ sender: UIButton) {
        guard let uuid = uuidTextField.text else {
            return
        }
        authentication.authorization(with: uuid)
    }
    
    @objc func successAuthentication(param: Notification) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    @objc func cancelAuthentication(param: Notification) {
        guard let error = (param.userInfo as? [String: Any])?["error"] as? Error else {
            return
        }
        DispatchQueue.main.async {
            self.alertConfiguration(with: error)
        }
    }
    
    func alertConfiguration(with error: Error) {
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

extension AuthenticationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
