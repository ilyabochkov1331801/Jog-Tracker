//
//  SendFeedbackViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class SendFeedbackViewController: UIViewController {

    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var topicPicker: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let activityView = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackTextView.layer.borderWidth = 1
        topicPicker.dataSource = self
        topicPicker.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardAction(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardAction(notification: )),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboardOnSwipeDown))
        swipeDown.delegate = self
        swipeDown.direction =  UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDown)
    }

    @IBAction func sendButtonTupped(_ sender: UIButton) {
        guard let textForFeedback = feedbackTextView.text else {
            return
        }
        let feedback = Feedback(topicId: topicPicker.selectedRow(inComponent: 0) + 1, feedback: textForFeedback)
        feedback.delegate = self
        feedback.sendFeedback()
        activityView.frame = CGRect(x: 0,
                                    y: 0,
                                    width: 100,
                                    height: 100)
        activityView.center = view.center
        view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    @objc func keyboardAction(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any], let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification {
            let inset = UIEdgeInsets(top: 0,
                                     left: 0,
                                     bottom: keyboardFrame.height - view.safeAreaInsets.bottom - 20,
                                     right: 0)
            scrollView.contentInset = inset
            scrollView.scrollIndicatorInsets = inset
        } else {
            scrollView.contentInset = .zero
            scrollView.scrollIndicatorInsets = .zero
        }
    }
    
    @objc func hideKeyboardOnSwipeDown() {
        feedbackTextView.resignFirstResponder()
    }
}

extension SendFeedbackViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        5
    }
}

extension SendFeedbackViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }
}

extension SendFeedbackViewController: UIGestureRecognizerDelegate {
    
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
