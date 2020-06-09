//
//  JogsService.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class JogsService {
    
    private let loadAllJogsURL = "https://jogtracker.herokuapp.com/api/v1/data/sync"
    private let addJogURL = "https://jogtracker.herokuapp.com/api/v1/data/jog"
    private let authentication = AuthenticationWithUUID.shared
    
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
        guard let url = URL(string: loadAllJogsURL + "?access_token=\(accessToken)") else {
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
            URLQueryItem(name: "access_token", value: accessToken),
            URLQueryItem(name: "distance", value: String(distance)),
            URLQueryItem(name: "time", value: String(time)),
            URLQueryItem(name: "date", value: ISO8601DateFormatter().string(from: date))
        ]
        
        guard let url = urlComponents.url else {
            completionHandler(nil, nil, JogsServiceErrors.urlError)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    func updateExisting(jog: Jog, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let accessToken = authentication.accessToken else {
            completionHandler(nil, nil, JogsServiceErrors.noAuthentication)
            return
        }
        guard var urlComponents = URLComponents(string: addJogURL) else {
            completionHandler(nil, nil, JogsServiceErrors.urlError)
            return
        }
                
        
        
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: accessToken),
            URLQueryItem(name: "distance", value: String(jog.distance)),
            URLQueryItem(name: "time", value: String(jog.time)),
            URLQueryItem(name: "date",
                         value: dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(jog.date)))),
            URLQueryItem(name: "jog_id", value: String(jog.id)),
            URLQueryItem(name: "user_id", value: String(jog.user_id))
        ]
        
        guard let url = urlComponents.url else {
            completionHandler(nil, nil, JogsServiceErrors.urlError)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
