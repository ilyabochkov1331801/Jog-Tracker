//
//  Jogs.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class Jogs {
    
    
    private(set) var jogsList: Array<Jog> = [] {
        didSet {
            delegate?.updatingDataDidFinished()
        }
    }
    
    var delegate: JogsDelegate?
    
    func appendToList(newJog: Jog) {
        var flag = false // костыль
        
        for (index, jog) in jogsList.enumerated() {
            if jog.id == newJog.id {
                jogsList[index] = newJog
                flag = true
            }
        }
        if !flag {
            jogsList.append(newJog)
        }
    }
    
    func loadFromAPI() {
        let jogsService = JogsService()
        jogsService.loadJogsList {
            [weak self] (data, response, error) in
            guard error == nil else {
                self?.delegate?.updatingDataDidFinished(with: error!)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                self?.delegate?.updatingDataDidFinished(with: JogsErrors.wrongResponse)
                return
            }
            switch response.statusCode {
            case 200 ..< 300:
                break
            default:
                self?.delegate?.updatingDataDidFinished(with: JogsErrors.badResponse(code: response.statusCode))
                return
            }
            guard let data = data,
                self?.updateJogsList(with: data) ?? false else {
                self?.delegate?.updatingDataDidFinished(with: AuthenticationErrors.wrongData)
                return
            }
        }
    }
    
    private func updateJogsList(with data: Data) -> Bool {
        guard let apiMessage = try? JSONDecoder().decode(ApiMessage.self, from: data) else {
            return false
        }
        jogsList = apiMessage.response.jogs
        return true
    }
}
