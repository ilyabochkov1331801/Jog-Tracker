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
    
    private let authorizationButtonText = "Let me in"
    private let testUUID = "hello"
    
    var authentication: AuthenticationService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authentication = AuthenticationService.shared
        navigationBarView = UIView()
        logoImageView = UIImageView()
        bearFaceImageView = UIImageView()
        authorizationButton = UIButton()
        authorizationButton.addTarget(self, action: #selector(authorizationButtonTupped), for: .touchUpInside)
        
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
            $0.edges.equalTo(navigationBarView).inset(UIEdgeInsets(top: 20, left: 25, bottom: 20, right: 252))
        }
        logoImageView.image = UIImage(named: ImageName.logoImageName)
        
        //MARK: AuthorizationButton Settings
        
        view.addSubview(authorizationButton)
        authorizationButton.snp.makeConstraints {
            $0.edges.equalTo(view).inset(UIEdgeInsets(top: 471, left: 112, bottom: 136, right: 112))
        }
        authorizationButton.layer.cornerRadius = 30
        authorizationButton.layer.borderWidth = 2
        authorizationButton.layer.borderColor = Colors.appPurple.cgColor
        authorizationButton.setTitle(authorizationButtonText, for: .normal)
        authorizationButton.setTitleColor(.purple, for: .normal)
        
        //MARK: BearFaceImageView Settings

        view.addSubview(bearFaceImageView)
        bearFaceImageView.snp.makeConstraints {
            $0.edges.equalTo(view).inset(UIEdgeInsets(top: 218, left: 107, bottom: 299, right: 107))
        }
        bearFaceImageView.image = UIImage(named: ImageName.bearFaceImageName)
    }
    
    @objc func authorizationButtonTupped(_ sender: UIButton) {
        authentication.authorization(with: testUUID) {
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
}
