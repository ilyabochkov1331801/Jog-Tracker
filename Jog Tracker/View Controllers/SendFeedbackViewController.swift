//
//  SendFeedbackViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class SendFeedbackViewController: UIViewController {

    //MARK: NavigationBar
    var navigationBarView: UIView!
    var logoImageView: UIImageView!
    var menuButton: UIButton!

    var feedbackTextView: UITextView!
    var topicNumberLabel: UILabel!
    var topicNumberTextField: UITextField!
    
    let activityView = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarView = UIView()
        logoImageView = UIImageView()
        menuButton = UIButton()
        
        feedbackTextView = UITextView()
        topicNumberLabel = UILabel()
        topicNumberTextField = UITextField()
        
        feedbackTextView.delegate = self
        topicNumberTextField.delegate = self
        
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
            make.height.size.equalTo(77)
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
        
        //MARK: FeedbackTextView Settings
        
        view.addSubview(feedbackTextView)
        feedbackTextView.snp.makeConstraints {
            (make) in
            make.top.equalTo(navigationBarView.snp.bottom).offset(20)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(200)
        }
        feedbackTextView.layer.borderWidth = 1
        feedbackTextView.layer.borderColor = UIColor.purple.cgColor
        
        //MARK: TopicNumberLabel and TopicNumberTextField Settings
        
        
    }

//    @IBAction func sendButtonTupped(_ sender: UIButton) {
//        guard let textForFeedback = feedbackTextView.text else {
//            return
//        }
//        let feedback = Feedback(topicId: topicPicker.selectedRow(inComponent: 0) + 1, feedback: textForFeedback)
//        feedback.delegate = self
//        feedback.sendFeedback()
//        activityView.frame = CGRect(x: 0,
//                                    y: 0,
//                                    width: 100,
//                                    height: 100)
//        activityView.center = view.center
//        activityView.hidesWhenStopped = true
//        view.addSubview(activityView)
//        activityView.startAnimating()
//    }
    
    @objc func openMenu() {
        let menuViewController =  MenuViewController()
        menuViewController.modalPresentationStyle = .fullScreen
        menuViewController.currentNavigationController = navigationController
        present(menuViewController, animated: true)
    }
}

extension SendFeedbackViewController: FeedbackDelegate {
    func feedbackWasPosted() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    func feedbackWasCancel(with error: Error) {
        DispatchQueue.main.async {
            self.alertConfiguration(with: error)
            self.activityView.stopAnimating()
        }
    }
    
    private func alertConfiguration(with error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default)
        let cancelAction = UIAlertAction(title: "Go to main screen",
                                         style: .cancel) {
                                            [weak self] (_) in
                                            self?.dismiss(animated: true)
                                            
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension SendFeedbackViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
