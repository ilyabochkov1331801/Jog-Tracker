//
//  InfoViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/26/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    private let titleText = "INFO"
    private let text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English."
    
    private let titleFont = UIFont(name: "SFUIText-Bold", size: 25)
    private let textFont = UIFont(name: "SFUIText-Regular", size: 12)
    
    //MARK: NavigationBar
    var navigationBarView: UIView!
    var logoImageView: UIImageView!
    var menuButton: UIButton!
    
    var titleLabel: UILabel!
    var textLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarView = UIView()
        logoImageView = UIImageView()
        menuButton = UIButton()
        titleLabel = UILabel()
        textLabel = UILabel()
        
        menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        
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
        
        //MARK: MenuButton Settings
        
        navigationBarView.addSubview(menuButton)
        menuButton.snp.makeConstraints {
            (make) in
            make.edges.equalTo(navigationBarView).inset(UIEdgeInsets(top: 27, left: 322, bottom: 26, right: 25))
        }
        menuButton.setImage(UIImage(named: ImageName.menuImageName), for: .normal)
        
        //MARK: TitleLabel Settings
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBarView.snp.bottom).offset(24)
            make.left.equalTo(view.snp.left).offset(25)
        }
        titleLabel.font = titleFont
        titleLabel.text = titleText
        titleLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        //MARK: TextLabel Settings
        
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints {
            (make) in
            make.left.equalTo(view.snp.left).offset(25)
            make.right.equalTo(view.snp.right).offset(-25)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
        }
        textLabel.font = textFont
        textLabel.text = text
        textLabel.numberOfLines = 0
    }
    
    @objc func openMenu() {
        let menuViewController =  MenuViewController()
        menuViewController.modalPresentationStyle = .fullScreen
        menuViewController.currentNavigationController = navigationController
        present(menuViewController, animated: true)
    }
}
