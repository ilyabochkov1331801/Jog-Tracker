//
//  AuthenticationViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    private let errorKey = "error"
    
    var authentication: AuthenticationWithUUID!
    
    @IBOutlet weak var authorizationButton: UIButton! {
        didSet {
            authorizationButton.layer.cornerRadius = authorizationButton.bounds.height / 2
        }
    }
    @IBOutlet weak var uuidTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authentication = AuthenticationWithUUID.shared
        uuidTextField.delegate = self
    }
    @IBAction func authorizationButtonTupped(_ sender: UIButton) {
        guard let uuid = uuidTextField.text else {
            return
        }
        authentication.authorization(with: uuid) {
            [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success():
                self.dismiss(animated: true)
            case .failure(let error):
                self.alertConfiguration(with: error)
            }
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
