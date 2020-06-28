//
//  Feedback.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class FeedbackService {
    
    private let keychainDataManager = KeychainDataManager()

    private let feedbackApiDataManager = FeedbackApiDataManager()
    
    func sendFeedback(text: String, topicNumber: Int, completionHandler: @escaping (Result<Void, Error>) -> ()) {
        guard let accessToken = keychainDataManager.accessToken() else {
            return
        }
        feedbackApiDataManager.sendFeedback(accessToken: accessToken, topicId: topicNumber, text: text) {
            switch $0 {
            case .success(_):
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
