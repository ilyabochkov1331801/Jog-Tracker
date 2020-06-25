//
//  MenuViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/25/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit
import SnapKit

class MenuViewController: UIViewController {
    
    private let jogsButtonText = "JOGS"
    private let infoButtonText = "INFO"
    private let contactButtonText = "CONTACT"
    private let closeButtonImageName = "closeImage"
    private let logoImageName = "logoGreenImage"

    var logoImageView: UIImageView!
    var closeButton: UIButton!
    var jogsButton: UIButton!
    var infoButton: UIButton!
    var contactButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView = UIImageView()
        closeButton = UIButton()
        jogsButton = UIButton()
        infoButton = UIButton()
        contactButton = UIButton()

        jogsButton.addTarget(self, action: #selector(jogsButtonTupped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        contactButton.addTarget(self, action: #selector(openFeedbackViewController), for: .touchUpInside)
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //MARK: JogsButton Settings
        
        view.addSubview(jogsButton)
        jogsButton.snp.makeConstraints {
            (make) in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: 183, left: 103, bottom: 433, right: 103))
        }
        jogsButton.setTitle(jogsButtonText, for: .normal)
        jogsButton.setTitleColor(.black, for: .normal)
        jogsButton.setTitleColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), for: .highlighted)
        
        //MARK: InfoButton Settings
        
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints {
            (make) in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: 233, left: 103, bottom: 383, right: 103))
        }
        infoButton.setTitle(infoButtonText, for: .normal)
        infoButton.setTitleColor(.black, for: .normal)
        infoButton.setTitleColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), for: .highlighted)
        
        //MARK: InfoButton Settings
        
        view.addSubview(contactButton)
        contactButton.snp.makeConstraints {
            (make) in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: 283, left: 103, bottom: 333, right: 103))
        }
        contactButton.setTitle(contactButtonText, for: .normal)
        contactButton.setTitleColor(.black, for: .normal)
        contactButton.setTitleColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), for: .highlighted)
        
        //MARK: CloseButton Settings
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            (make) in
            make.edges.equalTo(view.safeAreaInsets).inset(UIEdgeInsets(top: 28, left: 329, bottom: 618, right: 25))
        }
        closeButton.backgroundColor = .gray
        closeButton.setImage(UIImage(named: closeButtonImageName), for: .normal)
        
        //MARK: LogoImageView Settings
        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            (make) in
            make.edges.equalTo(view.safeAreaInsets).inset(UIEdgeInsets(top: 20, left: 25, bottom: 610, right: 252))
        }
        logoImageView.image = UIImage(named: logoImageName)
    }
    
    @objc func jogsButtonTupped() {
        dismiss(animated: true)
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
    
    @objc func openFeedbackViewController() {
        present(SendFeedbackViewController(), animated: true)
    }
}
