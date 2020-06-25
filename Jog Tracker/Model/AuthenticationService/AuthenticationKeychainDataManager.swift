//
//  AuthenticationKeychainDataManager.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/25/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class AuthenticationKeychainDataManager {
    private let accessTokenKey = "accessToken"
    
    func accessToken() -> String? {
        guard let newAccessTokenKey = KeychainWrapper.standard.string(forKey: accessTokenKey) else {
        return nil
        }
        return newAccessTokenKey
    }
    
    func logout() {
        KeychainWrapper.standard.removeObject(forKey: accessTokenKey)
    }
    
    func updateToken(with newAccessToken: String) {
        KeychainWrapper.standard.set(newAccessToken, forKey: accessTokenKey)
    }
}
