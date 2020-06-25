//
//  Jogs.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class JogsService {
    
    static var shared = JogsService()
    private init() { }
    
    private(set) var jogsList: Array<Jog> = [] {
        didSet {
            jogsCacheDataManager.updateToken(newJogsList: jogsList)
            delegate?.updatingDataDidFinished()
        }
    }

    private let authenticationService: AuthenticationService = AuthenticationService.shared
    
    private let jogsApiDataManager = JogsApiDataManager()
    private let jogsCacheDataManager = JogsCacheDataManager.shared
    
    var delegate: JogsServiceDelegate?
    
    func update(jog: Jog, completionHandler: @escaping (Result<Void, Error>) -> ()) {
        guard let accessToken = authenticationService.accessToken else {
            return
        }
        jogsApiDataManager.updateJog(with: accessToken, jog: jog) {
            switch $0 {
            case .success(let newJog):
                self.appendToList(newJog: newJog)
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func add(date: Date, time: Int, distance: Double, completionHandler: @escaping (Result<Void, Error>) -> ()) {
        guard let accessToken = authenticationService.accessToken else {
            return
        }
        jogsApiDataManager.addNewJog(with: accessToken, date: date, time: time, distance: distance) {
            switch $0 {
            case .success(let newJog):
                self.appendToList(newJog: newJog)
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func loadJogList(completionHandler: @escaping (Result<Void, Error>) -> ()) {
        guard let accessToken = authenticationService.accessToken else {
            return
        }
        if let cachedJogsList = jogsCacheDataManager.cachedJogsList() {
            jogsList = cachedJogsList
            completionHandler(.success(()))
        }
        jogsApiDataManager.loadJogsList(with: accessToken) {
            switch $0 {
            case .success(let newJogsList):
                self.jogsList = newJogsList
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
