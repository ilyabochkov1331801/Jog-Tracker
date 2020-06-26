//
//  ApiRequest.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/25/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

enum ApiRequest {
    
    private static var commonApiURL: String {
        return "https://jogtracker.herokuapp.com/api"
    }
    
    static func authenticationApiRequest(with UUID: String) -> URLRequest? {
        let authenticationApiURL = commonApiURL + "/v1/auth/uuidLogin"
        guard var urlComponents = URLComponents(string: authenticationApiURL) else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: ApiKeys.uuidKey, value: UUID)
        ]
        guard let url = urlComponents.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post
        return request
    }
    
    static func addNewJogRequest(accessToken: String, date: String, time: String, distance: String) -> URLRequest? {
        let addNewJogApiURL = commonApiURL + "/v1/data/jog"
        guard var urlComponents = URLComponents(string: addNewJogApiURL) else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: ApiKeys.accessTokenKey, value: accessToken),
            URLQueryItem(name: ApiKeys.distanceKey, value: distance),
            URLQueryItem(name: ApiKeys.timeKey, value: time),
            URLQueryItem(name: ApiKeys.dateKey, value: date)
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post
        return request
    }
    
    static func updateJogRequest(accessToken: String, distance: String, time: String, date: String, jogId: String, userId: String) -> URLRequest? {
        let updateJogApiURL = commonApiURL + "/v1/data/jog"
        guard var urlComponents = URLComponents(string: updateJogApiURL) else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: ApiKeys.accessTokenKey, value: accessToken),
            URLQueryItem(name: ApiKeys.distanceKey, value: distance),
            URLQueryItem(name: ApiKeys.timeKey, value: time),
            URLQueryItem(name: ApiKeys.dateKey,value: date),
            URLQueryItem(name: ApiKeys.jogIdKey, value: jogId),
            URLQueryItem(name: ApiKeys.userIdKey, value: userId)
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put
        return request
    }
    
    static func loadJogsListRequest(accessToken: String) -> URLRequest? {
        let loadJogsListApiURL = commonApiURL + "/v1/data/sync"
        guard var urlComponents = URLComponents(string: loadJogsListApiURL) else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: ApiKeys.accessTokenKey, value: accessToken)
        ]
        guard let url = urlComponents.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    static func feedbackRequest(accessToken: String, feedback: String, topicNumber: String) -> URLRequest? {
        let feedbackApiURL = commonApiURL + "/v1/feedback/send"
        guard var urlComponents = URLComponents(string: feedbackApiURL) else {
            return nil
        }
                
        urlComponents.queryItems = [
            URLQueryItem(name: ApiKeys.accessTokenKey, value: accessToken),
            URLQueryItem(name: ApiKeys.topicIdKey, value: topicNumber),
            URLQueryItem(name: ApiKeys.feedbackKey, value: feedback)
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post
        return request
    }
}

