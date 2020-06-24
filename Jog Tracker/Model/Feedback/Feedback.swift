//
//  Feedback.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class Feedback {
    
    private let urlForFeedback = "https://jogtracker.herokuapp.com/api/v1/feedback/send"
    private let authentication: Authentication = Authentication.shared
    
    //MARK: Constants
    private let post = "POST"
    private let accessTokenKey = "access_token"
    private let topicIdKey = "topic_id"
    private let feedbackKey = "text"
    
    var topicId: Int
    var feedback: String
    
    init(topicId: Int, feedback: String) {
        self.topicId = topicId
        self.feedback = feedback
    }
    
    func sendFeedback(completionHandler: @escaping (Result<Void, Error>) -> ()) {
        let networkingService = NetworkingService<FeedbackResponseMessage>()
        guard let request = configureRequest() else {
            return
        }
        networkingService.makeURLRequest(with: request) {
            (result) in
            switch result {
            case .success(_):
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func configureRequest() -> URLRequest? {
        guard let accessToken = authentication.accessToken else {
            return nil
        }
        guard var urlComponents = URLComponents(string: urlForFeedback) else {
            return nil
        }
                
        urlComponents.queryItems = [
            URLQueryItem(name: accessTokenKey, value: accessToken),
            URLQueryItem(name: topicIdKey, value: String(topicId)),
            URLQueryItem(name: feedbackKey, value: feedback)
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = post
        return request
    }
}
