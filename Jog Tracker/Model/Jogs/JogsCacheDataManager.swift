//
//  JogsCacheDataManager.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/25/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class JogsCacheDataManager {
    
    static let shared = JogsCacheDataManager()
    private init() {}
    
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
    
    func updateToken(newJogsList: Array<Jog>) {
        jogsList = newJogsList
    }
}
