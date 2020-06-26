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
    
    private let keychainDataManager = KeychainDataManager()
    
    private let jogsApiDataManager = JogsApiDataManager()
    private let jogsCacheDataManager = JogsCacheDataManager()
        
    func update(jog: Jog, completionHandler: @escaping (Result<Void, Error>) -> ()) {
        guard let accessToken = keychainDataManager.accessToken() else {
            return
        }
        jogsApiDataManager.updateJog(with: accessToken, jog: jog) {
            switch $0 {
            case .success(let newJog):
                self.jogsCacheDataManager.updateCache(newJog: newJog)
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func add(date: Date, time: Int, distance: Double, completionHandler: @escaping (Result<Void, Error>) -> ()) {
        guard let accessToken = keychainDataManager.accessToken() else {
            return
        }
        jogsApiDataManager.addNewJog(with: accessToken, date: date, time: time, distance: distance) {
            switch $0 {
            case .success(let newJog):
                self.jogsCacheDataManager.updateCache(newJog: newJog)
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getJogs(completionHandler: @escaping (Result<Array<Jog>, Error>) -> ()) {
        if let cachedJogsList = jogsCacheDataManager.cachedJogsList() {
            completionHandler(.success(cachedJogsList))
        } else {
            guard let accessToken = keychainDataManager.accessToken() else {
                return
            }
            jogsApiDataManager.loadJogsList(with: accessToken) {
                switch $0 {
                case .success(let newJogsList):
                    self.jogsCacheDataManager.updateCache(newJogsList: newJogsList)
                    completionHandler(.success(newJogsList))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
}
