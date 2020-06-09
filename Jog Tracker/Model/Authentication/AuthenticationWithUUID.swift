//
//  Authentication.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class AuthenticationWithUUID: Authentication {
    static var shared: Authentication = AuthenticationWithUUID()
    
    private let userDefaultsKey = "accessToken"
    
    private init() { }
    
    var accessToken: String? {
        guard let newAccessToken = KeychainWrapper.standard.string(forKey: userDefaultsKey) else {
            return nil
        }
        return newAccessToken
    }
    
    var isAuthorized: Bool {
        return accessToken != nil
    }
    
    func authorization(with UUID: String) -> () {
        let authenticationService = AuthenticationService()
        authenticationService.authorization(with: UUID) {
            [weak self] (data, response, error) in
            guard error == nil else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "authenticationPassedWithError"), object: nil, userInfo: ["error": error!])
                return
            }
            guard let response = response as? HTTPURLResponse else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "authenticationPassedWithError"), object: nil, userInfo: ["error": AuthenticationErrors.wrongResponse])
                return
            }
            switch response.statusCode {
            case 200 ..< 300:
                break
            default:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "authenticationPassedWithError"), object: nil, userInfo: ["error": AuthenticationErrors.badResponse(code: response.statusCode)])
                return
            }
            guard let data = data,
                self?.updateToken(with: data) ?? false else {
                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "authenticationPassedWithError"), object: nil, userInfo: ["error": AuthenticationErrors.wrongData])
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "authenticationPassed"), object: nil)
        }
    }
    
    private func updateToken(with data: Data) -> Bool {
        guard let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let response = responseDictionary["response"] as? [String: Any],
            let newAccessToken = response["access_token"] as? String else {
            return false
        }
        KeychainWrapper.standard.set(newAccessToken, forKey: userDefaultsKey)
        return true
    }
}
