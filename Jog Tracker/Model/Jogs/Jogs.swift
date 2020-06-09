//
//  Jogs.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class Jogs {
    
    static var shared = Jogs()
    
    private init() { }
    
    private(set) var jogsList: Array<Jog> = [] {
        didSet {
            delegate?.updatingDataDidFinished()
        }
    }
    
    private var commonCompletionHandler: (_ target: Jogs,  _ data: Data?, _ response: URLResponse?, _ error: Error?, _ dataCombiner: (Data) -> Bool) -> () = {
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
    
    var delegate: JogsDelegate?
    
    func append(newJog: Jog) {
        
        let jogsService = JogsService()
        jogsService.updateExisting(jog: newJog) {
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
    
    private let dateFormatter: ISO8601DateFormatter = {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate,
                                   .withTime,
                                   .withDashSeparatorInDate,
                                   .withColonSeparatorInTime]
        return dateFormatter
    }()
    
    func append(date: Date, time: Int, distance: Double) {
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
    
    func loadFromAPI() {
        let jogsService = JogsService()
        jogsService.loadJogsList {
            [weak self] (data, response, error) in
            guard let self = self else {
                return
            }
            self.commonCompletionHandler(self, data, response, error) {
                data in
                return self.loadJogsList(with: data)
            }
        }
    }
    
    private func loadJogsList(with data: Data) -> Bool {
        guard let apiMessage = try? JSONDecoder().decode(ApiMessage.self, from: data) else {
            return false
        }
        jogsList = apiMessage.response.jogs
        return true
    }
    
    private func appendToJogsList(with data: Data) -> Bool {
        guard let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let response = responseDictionary["response"] as? [String: Any],
            let id = response["id"] as? Int,
            let userId = response["user_id"] as? Int,
            let distance = response["distance"] as? Double,
            let time = response["time"] as? Int,
            let isoDate = response["date"] as? String,
            let date = dateFormatter.date(from: isoDate) else {
                return false
        }
        
        let newJog = Jog(id: id, user_id: String(userId), distance: distance, time: time, date: Int(date.timeIntervalSince1970))
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
