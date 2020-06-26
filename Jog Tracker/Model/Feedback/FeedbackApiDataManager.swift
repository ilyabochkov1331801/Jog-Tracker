//
//  FeedbackApiDataManager.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/25/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class FeedbackApiDataManager: ApiDataManager {
    func sendFeedback(accessToken: String, topicId: Int, text: String, completionHandler: @escaping (Result<String, Error>) -> ()) {
        guard let request = ApiRequest.feedbackRequest(accessToken: accessToken,
                                                       feedback: text,
                                                       topicNumber: String(topicId)) else {
                                                        completionHandler(.failure(ApiDataManagerErrors.nilRequest))
                                                        return
        }
        makeURLRequest(with: request) { (result: Result<FeedbackResponseMessage, Error>) in
            switch result {
                case .success(let newFeedbackResponseMessage):
                    completionHandler(.success(newFeedbackResponseMessage.response))
            case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
}
