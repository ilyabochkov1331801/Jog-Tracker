//
//  FeedbackService.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class FeedbackService {
    private let urlForFeedback = "https://jogtracker.herokuapp.com/api/v1/feedback/send"
    private let authentication: Authentication = AuthenticationWithUUID.shared
    
    //MARK: Constants
    private let post = "POST"
    private let accessTokenKey = "access_token"
    private let topicIdKey = "topic_id"
    private let feedbackKey = "text"
    
    func send(feedback: String, topicId: Int, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let accessToken = authentication.accessToken else {
            return
        }
        guard var urlComponents = URLComponents(string: urlForFeedback) else {
            return
        }
                
        urlComponents.queryItems = [
            URLQueryItem(name: accessTokenKey, value: accessToken),
            URLQueryItem(name: topicIdKey, value: String(topicId)),
            URLQueryItem(name: feedbackKey, value: feedback)
        ]
        
        guard let url = urlComponents.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = post
        
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
