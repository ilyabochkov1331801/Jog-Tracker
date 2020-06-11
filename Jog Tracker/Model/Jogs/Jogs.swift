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
    
    //MARK: Constants
    private let responseKey = "response"
    private let idKey = "id"
    private let userIdKey = "user_id"
    private let distanceKey = "distance"
    private let timeKey = "time"
    private let dateKey = "date"
    
    private lazy var commonCompletionHandler: (_ target: Jogs,  _ data: Data?, _ response: URLResponse?, _ error: Error?, _ dataCombiner: (Data) -> Bool) -> () = {
        (target, data, response, error, dataCombiner) in
        
        guard error == nil else {
            target.delegate?.updatingDataDidFinished(with: error!)
            return
        }
        guard let response = response as? HTTPURLResponse else {
            target.delegate?.updatingDataDidFinished(with: JogsErrors.wrongResponse)
            return
        }
        switch response.statusCode {
        case 200 ..< 300:
            break
        default:
            target.delegate?.updatingDataDidFinished(with: JogsErrors.badResponse(code: response.statusCode))
            return
        }
        guard let data = data,
            dataCombiner(data) else {
            target.delegate?.updatingDataDidFinished(with: JogsErrors.wrongData)
            return
        }
    }
    
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
    func append(newJog: Jog) {
        DispatchQueue.global(qos: .userInteractive).async {
            let jogsService = JogsService()
            jogsService.addNew(jog: newJog) {
                [weak self] (data, response, error) in
                guard let self = self else {
                    return
                }
                self.commonCompletionHandler(self, data, response, error) {
                    data in
                    return self.appendToJogsList(with: data)
                }
            }
        }
    }
    
    func append(date: Date, time: Int, distance: Double) {
        DispatchQueue.global(qos: .userInteractive).async {
            let jogsService = JogsService()
            jogsService.addNew(date: date, time: time, distance: distance) {
                [weak self] (data, response, error) in
                guard let self = self else {
                    return
                }
                self.commonCompletionHandler(self, data, response, error) {
                    data in
                    return self.appendToJogsList(with: data)
                }
            }
        }
    }
    
    func loadFromAPI() {
        DispatchQueue.global(qos: .userInteractive).async {
            let jogsService = JogsService()
            jogsService.loadJogsList {
                [weak self] (data, response, error) in
                guard let self = self else {
                    return
                }
                self.commonCompletionHandler(self, data, response, error) {
                    data in
                    return self.loadNewJogsList(with: data)
                }
            }
        }
    }
    
    
    private func loadNewJogsList(with data: Data) -> Bool {
        guard let apiMessage = try? JSONDecoder().decode(ApiMessage.self, from: data) else {
            return false
        }
        jogsList = apiMessage.response.jogs
        return true
    }
    
    private func appendToJogsList(with data: Data) -> Bool {
        guard let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let response = responseDictionary[responseKey] as? [String: Any],
            let id = response[idKey] as? Int,
            let userId = response[userIdKey] as? Int,
            let distance = response[distanceKey] as? Double,
            let time = response[timeKey] as? Int,
            let isoDate = response[dateKey] as? String,
            let date = dateFormatter.date(from: isoDate) else {
                return false
        }
        
        let newJog = Jog(id: id, user_id: String(userId), distance: distance, time: time, date: date.timeIntervalSince1970)
        self.appendToList(newJog: newJog)
        return true
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
