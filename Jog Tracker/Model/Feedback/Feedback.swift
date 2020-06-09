//
//  Feedback.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class Feedback {
    var topicId: Int
    var feedback: String
    var delegate: FeedbackDelegate?
    
    init(topicId: Int, feedback: String) {
        self.topicId = topicId
        self.feedback = feedback
    }
    
    func sendFeedback() {
        FeedbackService().send(feedback: self) {
            (data, response, error) in
            guard error == nil else {
                self.delegate?.feedbackWasCancel(with: error!)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                self.delegate?.feedbackWasCancel(with: FeedbackErrors.wrongResponse)
                return
            }
            switch response.statusCode {
            case 200 ..< 300:
                break
            default:
                self.delegate?.feedbackWasCancel(with: FeedbackErrors.badResponse(code: response.statusCode))
                return
            }
            self.delegate?.feedbackWasPosted()
        }
    }
}
