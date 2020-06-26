//
//  JogsCacheDataManager.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/25/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class JogsCacheDataManager {
    
    private var jogsList: Array<Jog>?
    
    func cachedJogsList() -> Array<Jog>? {
        guard let jogsList = jogsList else {
            return nil
        }
        return jogsList
    }
    
    func clearCache() {
        jogsList = nil
    }
    
    func updateCache(newJog: Jog) {
        appendToList(newJog: newJog)
    }
    
    func updateCache(newJogsList: Array<Jog>) {
        jogsList = newJogsList
    }
    
    private func appendToList(newJog: Jog) {
        
        let updatedJogIndex = jogsList?.firstIndex {
            $0.id == newJog.id
        }
        if let updatedJogIndex = updatedJogIndex {
            jogsList?[updatedJogIndex] = newJog
        } else {
            jogsList?.append(newJog)
        }
    }
}
