//
//  AuthenticationViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    //MARK: NavigationBar
    var navigationBarView: UIView!
    var logoImageView: UIImageView!
    var authorizationButton: UIButton!
    var bearFaceImageView: UIImageView!
    
    private let errorKey = "error"
    private let authorizationButtonText = "Let me in"
    private let testUUID = "hello"
    
    var authentication: Authentication!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarView = UIView()
        logoImageView = UIImageView()
        bearFaceImageView = UIImageView()
        authorizationButton = UIButton()
        authorizationButton.addTarget(self, action: #selector(authorizationButtonTupped), for: .touchUpInside)
        
        authentication = AuthenticationWithUUID.shared
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(successAuthentication(param:)),
                                               name: .AuthenticationPassed,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cancelAuthentication(param:)),
                                               name: .AuthenticationPassedWithError,
                                               object: nil)
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //MARK: NavigationBarView Settings
        
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints {
            (make) in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(77)
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
        
        //MARK: AuthorizationButton Settings
        
        view.addSubview(authorizationButton)
        authorizationButton.snp.makeConstraints {
            (make) in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: 471, left: 112, bottom: 136, right: 112))
        }
        authorizationButton.layer.cornerRadius = 30
        authorizationButton.layer.borderWidth = 2
        authorizationButton.layer.borderColor = UIColor.purple.cgColor
        authorizationButton.setTitle(authorizationButtonText, for: .normal)
        authorizationButton.setTitleColor(.purple, for: .normal)
        
        //MARK: BearFaceImageView Settings

        view.addSubview(bearFaceImageView)
        bearFaceImageView.snp.makeConstraints {
            (make) in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: 218, left: 107, bottom: 299, right: 107))
        }
        bearFaceImageView.image = UIImage(named: ImageName.bearFaceImageName)
    }
    
    @objc func authorizationButtonTupped(_ sender: UIButton) {
        authentication.authorization(with: testUUID)
    }
    
    @objc func successAuthentication(param: Notification) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    @objc func cancelAuthentication(param: Notification) {
        guard let error = (param.userInfo as? [String: Any])?[errorKey] as? Error else {
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
