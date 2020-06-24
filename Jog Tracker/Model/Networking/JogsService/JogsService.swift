//
//  JogsService.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class JogsService {
    
    //MARK: URLs
    private let loadAllJogsURL = "https://jogtracker.herokuapp.com/api/v1/data/sync"
    private let addJogURL = "https://jogtracker.herokuapp.com/api/v1/data/jog"
    
    //MARK: Constants
    private let accessTokenKey = "access_token"
    private let distanceKey = "distance"
    private let timeKey = "time"
    private let dateKey = "date"
    private let jogIdKey = "jog_id"
    private let userIdKey = "user_id"
    private let post = "POST"
    private let put = "PUT"
    
    //MARK: Authentication
    private let authentication: AuthenticationWithUUID = AuthenticationWithUUID.shared
    
    private let dateFormatter: ISO8601DateFormatter = {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate,
                                   .withTime,
                                   .withDashSeparatorInDate,
                                   .withColonSeparatorInTime]
        return dateFormatter
    }()
    
    func loadJogsList(completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let accessToken = authentication.accessToken else {
            completionHandler(nil, nil, JogsServiceErrors.noAuthentication)
            return
        }
        guard var urlComponents = URLComponents(string: loadAllJogsURL) else {
            completionHandler(nil, nil, JogsServiceErrors.urlError)
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: accessTokenKey, value: accessToken)
        ]
        guard let url = urlComponents.url else {
            completionHandler(nil, nil, JogsServiceErrors.urlError)
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: completionHandler).resume()
    }
    
    func addNew(date: Date, time: Int, distance: Double, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let accessToken = authentication.accessToken else {
            completionHandler(nil, nil, JogsServiceErrors.noAuthentication)
            return
        }
        guard var urlComponents = URLComponents(string: addJogURL) else {
            completionHandler(nil, nil, JogsServiceErrors.urlError)
            return
        }
                
        urlComponents.queryItems = [
            URLQueryItem(name: accessTokenKey, value: accessToken),
            URLQueryItem(name: distanceKey, value: String(distance)),
            URLQueryItem(name: timeKey, value: String(time)),
            URLQueryItem(name: dateKey, value: ISO8601DateFormatter().string(from: date))
        ]
        
        guard let url = urlComponents.url else {
            completionHandler(nil, nil, JogsServiceErrors.urlError)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = post
        
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    func addNew(jog: Jog, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let accessToken = authentication.accessToken else {
            completionHandler(nil, nil, JogsServiceErrors.noAuthentication)
            return
        }
        guard var urlComponents = URLComponents(string: addJogURL) else {
            completionHandler(nil, nil, JogsServiceErrors.urlError)
            return
        }
                
        urlComponents.queryItems = [
            URLQueryItem(name: accessTokenKey, value: accessToken),
            URLQueryItem(name: distanceKey, value: String(jog.distance)),
            URLQueryItem(name: timeKey, value: String(jog.time)),
            URLQueryItem(name: dateKey,
                         value: dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(jog.date)))),
            URLQueryItem(name: jogIdKey, value: String(jog.id)),
            URLQueryItem(name: userIdKey, value: String(jog.user_id))
        ]
        
        guard let url = urlComponents.url else {
            completionHandler(nil, nil, JogsServiceErrors.urlError)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = put
        
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
}
