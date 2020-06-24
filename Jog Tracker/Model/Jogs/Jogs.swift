//
//  Jogs.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class Jogs {
    
    //MARK: Singletone
    static var shared = Jogs()
    private init() { }
    
    private(set) var jogsList: Array<Jog> = [] {
        didSet {
            delegate?.updatingDataDidFinished()
        }
    }

    private let authentication: Authentication = Authentication.shared
    
    //MARK: Constants
    private let loadAllJogsURL = "https://jogtracker.herokuapp.com/api/v1/data/sync"
    private let addJogURL = "https://jogtracker.herokuapp.com/api/v1/data/jog"
    
    private let accessTokenKey = "access_token"
    private let distanceKey = "distance"
    private let timeKey = "time"
    private let dateKey = "date"
    private let jogIdKey = "jog_id"
    private let userIdKey = "user_id"
    private let post = "POST"
    private let put = "PUT"
        
    private lazy var dateFormatter: ISO8601DateFormatter = {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate,
                                   .withTime,
                                   .withDashSeparatorInDate,
                                   .withColonSeparatorInTime]
        return dateFormatter
    }()
    
    //MARK: Delegate for updating data
    var delegate: JogsDelegate?
    
    //MARK: Update jogsList
    func append(newJog: Jog, completionHandler: @escaping (Result<Void, Error>) -> ()) {
        guard let request = configureRequestForUpdating(jog: newJog) else {
            return
        }
        appendJog(with: request, completionHandler: completionHandler)
    }
    
    func append(date: Date, time: Int, distance: Double, completionHandler: @escaping (Result<Void, Error>) -> ()) {
    
        guard let request = configureRequestForAppendingNewJogToJogList(date: date,
                                                                        time: time,
                                                                        distance: distance) else {
            return
        }
        
        appendJog(with: request, completionHandler: completionHandler)
    }
    
    func loadFromAPI(completionHandler: @escaping (Result<Void, Error>) -> ()) {
            
        guard let request = configureRequestForLoadJogList() else {
            return
        }
        let networkingService = NetworkingService<JogsResponseMessage>()
        networkingService.makeURLRequest(with: request) {
            (result) in
            switch result {
            case .success(let newJogsResponseMessage):
                self.jogsList = newJogsResponseMessage.response.jogs
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func configureRequestForLoadJogList() -> URLRequest? {
        guard let accessToken = authentication.accessToken else {
            return nil
        }
        guard var urlComponents = URLComponents(string: loadAllJogsURL) else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: accessTokenKey, value: accessToken)
        ]
        guard let url = urlComponents.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    private func configureRequestForUpdating(jog: Jog) -> URLRequest? {
        guard let accessToken = authentication.accessToken else {
            return nil
        }
        guard var urlComponents = URLComponents(string: addJogURL) else {
            return nil
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
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = put
        return request
    }
    
    private func configureRequestForAppendingNewJogToJogList(date: Date, time: Int, distance: Double) -> URLRequest? {
        guard let accessToken = authentication.accessToken else {
            return nil
        }
        guard var urlComponents = URLComponents(string: addJogURL) else {
            return nil
        }
                
        urlComponents.queryItems = [
            URLQueryItem(name: accessTokenKey, value: accessToken),
            URLQueryItem(name: distanceKey, value: String(distance)),
            URLQueryItem(name: timeKey, value: String(time)),
            URLQueryItem(name: dateKey, value: dateFormatter.string(from: date))
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = post
        return request
    }
    
    private func appendJog(with request: URLRequest, completionHandler: @escaping (Result<Void, Error>) -> ()) {
        let networkingService = NetworkingService<UpdatedJogResponseMessage>()
        networkingService.makeURLRequest(with: request) {
            (result) in
            switch result {
                case .success(let newJogsResponseMessage):
                    let updatedJog = newJogsResponseMessage.response
                    let newJog = Jog(id: updatedJog.id,
                                     user_id: String(updatedJog.user_id),
                                     distance: updatedJog.distance,
                                     time: updatedJog.time,
                                     date: self.dateFormatter.date(from: updatedJog.date)!.timeIntervalSince1970)
                    self.appendToList(newJog: newJog)
                    completionHandler(.success(()))
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
    
    private func appendToList(newJog: Jog) {
        var flag = false
        for (index, jog) in jogsList.enumerated() {
            if jog.id == newJog.id {
                jogsList[index] = newJog
                flag = true
                break
            }
        }
        if !flag {
            jogsList.append(newJog)
        }
    }
}
