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
    var sendButton: UIButton!
    
    let activityView = UIActivityIndicatorView(style: .gray)
    let topicNumberLabelText = "Topic number:"
    let sendFeedbackButtonText = "Send"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarView = UIView()
        logoImageView = UIImageView()
        menuButton = UIButton()
        
        feedbackTextView = UITextView()
        topicNumberLabel = UILabel()
        topicNumberTextField = UITextField()
        sendButton = UIButton()
        
        feedbackTextView.delegate = self
        topicNumberTextField.delegate = self
        
        menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonTupped), for: .touchUpInside)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeDown.direction = .down
        swipeDown.delegate = self
        view.addGestureRecognizer(swipeDown)
        
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
        navigationBarView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        //MARK: LogoImageView Settings
        
        navigationBarView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.edges.equalTo(navigationBarView).inset(UIEdgeInsets(top: 20, left: 25, bottom: 20, right: 252))
        }
        logoImageView.image = UIImage(named: ImageName.logoImageName)
        
        //MARK: MenuButton Settings
        
        navigationBarView.addSubview(menuButton)
        menuButton.snp.makeConstraints {
            $0.edges.equalTo(navigationBarView).inset(UIEdgeInsets(top: 27, left: 322, bottom: 26, right: 25))
        }
        menuButton.setImage(UIImage(named: ImageName.menuImageName), for: .normal)
        
        //MARK: FeedbackTextView Settings
        
        view.addSubview(feedbackTextView)
        feedbackTextView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(20)
            $0.left.equalTo(view.snp.left).offset(20)
            $0.right.equalTo(view.snp.right).offset(-20)
            $0.height.equalTo(200)
        }
        feedbackTextView.layer.borderWidth = 1
        feedbackTextView.layer.borderColor = UIColor.purple.cgColor
        
        //MARK: TopicNumberLabel and TopicNumberTextField Settings
        
        view.addSubview(topicNumberLabel)
        topicNumberLabel.snp.makeConstraints {
            $0.top.equalTo(feedbackTextView.snp.bottom).offset(26)
            $0.left.equalTo(view.snp.left).offset(20)
        }
        topicNumberLabel.text = topicNumberLabelText
        view.addSubview(topicNumberTextField)
        topicNumberTextField.snp.makeConstraints {
            $0.top.equalTo(feedbackTextView.snp.bottom).offset(20)
            $0.left.equalTo(topicNumberLabel.snp.right).offset(20)
            $0.right.equalTo(view.snp.right).offset(-20)
        }
        topicNumberTextField.borderStyle = .roundedRect
        
        //MARK: SendButton Settings
        
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(60)
            $0.width.equalTo(251)
            $0.top.equalTo(topicNumberTextField.snp.bottom).offset(20)
        }
        sendButton.layer.cornerRadius = 30
        sendButton.layer.borderColor = UIColor.purple.cgColor
        sendButton.layer.borderWidth = 2
        sendButton.setTitle(sendFeedbackButtonText, for: .normal)
        sendButton.setTitleColor(.purple, for: .normal)
    }

    @objc func sendButtonTupped() {
        guard let textForFeedback = feedbackTextView.text else {
            return
        }
        guard let topicIdString = topicNumberTextField.text,
            let topicId = Int(topicIdString) else {
                return
        }
        let feedback = Feedback(topicId: topicId, feedback: textForFeedback)
        feedback.delegate = self
        feedback.sendFeedback()
        activityView.frame = CGRect(x: 0,
                                    y: 0,
                                    width: 100,
                                    height: 100)
        activityView.center = view.center
        activityView.hidesWhenStopped = true
        view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
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
            self.activityView.stopAnimating()
            let menuViewController =  MenuViewController()
            menuViewController.modalPresentationStyle = .fullScreen
            menuViewController.currentNavigationController = self.navigationController
            self.present(menuViewController, animated: true)
        }
    }
    
    func feedbackWasCancel(with error: Error) {
        DispatchQueue.main.async {
            self.activityView.stopAnimating()
            self.alertConfiguration(with: error)
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

extension SendFeedbackViewController: UIGestureRecognizerDelegate {
    
}
