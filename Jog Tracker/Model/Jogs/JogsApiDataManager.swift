//
//  JogsDataManager.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/25/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class JogsApiDataManager: ApiDataManager {
    
    private var dateFormatter: ISO8601DateFormatter {
        let newDateFormatter = ISO8601DateFormatter()
        newDateFormatter.formatOptions = [.withFullDate,
                                   .withTime,
                                   .withDashSeparatorInDate,
                                   .withColonSeparatorInTime]
        return newDateFormatter
    }
    
    func loadJogsList(with accessToken: String, completionHandler: @escaping (Result<Array<Jog>, Error>) -> ()) {
        guard let request = ApiRequest.loadJogsListRequest(accessToken: accessToken) else {
            completionHandler(.failure(ApiDataManagerErrors.nilRequest))
            return
        }
        super.makeURLRequest(with: request) { (result: Result<JogsResponseMessage, Error>) in
            switch result {
                case .success(let newJogsResponseMessage):
                    completionHandler(.success(newJogsResponseMessage.response.jogs))
            case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
    
    func addNewJog(with accessToken: String, date: Date, time: Int, distance: Double, completionHandler: @escaping (Result<Jog, Error>) -> ()) {
        guard let request = ApiRequest.addNewJogRequest(accessToken: accessToken,
                                                        date: dateFormatter.string(from: date),
                                                        time: String(time),
                                                        distance: String(distance)) else {
                                                           completionHandler(.failure(ApiDataManagerErrors.nilRequest))
                                                            return
        }
        super.makeURLRequest(with: request) { (result: Result<UpdatedJogResponseMessage, Error>) in
            switch result {
                case .success(let newUpdatedJogResponseMessage):
                    let updatedJog = newUpdatedJogResponseMessage.response
                    let newJog = Jog(id: updatedJog.id,
                                    userId: String(updatedJog.userId),
                                    distance: updatedJog.distance,
                                    time: updatedJog.time,
                                    date: self.dateFormatter.date(from: updatedJog.date)!.timeIntervalSince1970)
                    completionHandler(.success(newJog))
            case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
    
    func updateJog(with accessToken: String, jog: Jog, completionHandler: @escaping (Result<Jog, Error>) -> ()) {
        guard let request = ApiRequest.updateJogRequest(accessToken: accessToken,
                                                        distance: String(jog.distance),
                                                        time: String(jog.time),
                                                        date: dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(jog.date))),
                                                        jogId: String(jog.id),
                                                        userId: jog.userId) else {
                                                            completionHandler(.failure(ApiDataManagerErrors.nilRequest))
                                                            return
        }
        super.makeURLRequest(with: request) { (result: Result<UpdatedJogResponseMessage, Error>) in
            switch result {
                case .success(let newUpdatedJogResponseMessage):
                    let updatedJog = newUpdatedJogResponseMessage.response
                    let newJog = Jog(id: updatedJog.id,
                                    userId: String(updatedJog.userId),
                                    distance: updatedJog.distance,
                                    time: updatedJog.time,
                                    date: self.dateFormatter.date(from: updatedJog.date)!.timeIntervalSince1970)
                    completionHandler(.success(newJog))
            case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
}
