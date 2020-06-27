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

    var currentNavigationController: UINavigationController?
    
    private var logoImageView: UIImageView!
    private var closeButton: UIButton!
    private var jogsButton: UIButton!
    private var infoButton: UIButton!
    private var contactButton: UIButton!
    
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
        infoButton.addTarget(self, action: #selector(openInfoViewController), for: .touchUpInside)
        
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //MARK: JogsButton Settings
        
        view.addSubview(jogsButton)
        jogsButton.snp.makeConstraints {
            $0.edges.equalTo(view).inset(UIEdgeInsets(top: 183, left: 103, bottom: 433, right: 103))
        }
        jogsButton.setTitle(jogsButtonText, for: .normal)
        jogsButton.titleLabel?.font = Fonts.menuVCButtonTextFont
        jogsButton.setTitleColor(.black, for: .normal)
        jogsButton.setTitleColor(Colors.appGreen, for: .highlighted)
        
        //MARK: InfoButton Settings
        
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints {
            $0.edges.equalTo(view).inset(UIEdgeInsets(top: 233, left: 103, bottom: 383, right: 103))
        }
        infoButton.setTitle(infoButtonText, for: .normal)
        infoButton.titleLabel?.font = Fonts.menuVCButtonTextFont
        infoButton.setTitleColor(.black, for: .normal)
        infoButton.setTitleColor(Colors.appGreen, for: .highlighted)
        
        //MARK: InfoButton Settings
        
        view.addSubview(contactButton)
        contactButton.snp.makeConstraints {
            $0.edges.equalTo(view).inset(UIEdgeInsets(top: 283, left: 103, bottom: 333, right: 103))
        }
        contactButton.setTitle(contactButtonText, for: .normal)
        contactButton.titleLabel?.font = Fonts.menuVCButtonTextFont
        contactButton.setTitleColor(.black, for: .normal)
        contactButton.setTitleColor(Colors.appGreen, for: .highlighted)
        
        //MARK: CloseButton Settings
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaInsets).inset(UIEdgeInsets(top: 28, left: 329, bottom: 618, right: 25))
        }
        closeButton.backgroundColor = .gray
        closeButton.setImage(UIImage(named: closeButtonImageName), for: .normal)
        
        //MARK: LogoImageView Settings
        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaInsets).inset(UIEdgeInsets(top: 20, left: 25, bottom: 610, right: 252))
        }
        logoImageView.image = UIImage(named: ImageName.logoGreenImageName)
    }
    
    @objc private func jogsButtonTupped() {
        currentNavigationController?.viewControllers = [ JogsViewController() ]
        dismiss(animated: true)
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
    
    @objc private func openFeedbackViewController() {
        currentNavigationController?.viewControllers = [ SendFeedbackViewController() ]
        dismiss(animated: true)
    }
    
    @objc private func openInfoViewController() {
        currentNavigationController?.viewControllers = [ InfoViewController() ]
        dismiss(animated: true)
    }
}
