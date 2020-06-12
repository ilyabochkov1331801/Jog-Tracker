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
    
    //MARK: Singletone
    static var shared: Authentication = AuthenticationWithUUID()
    private init() { }
    
    //MARK: Constants
    private let userDefaultsKey = "accessToken"
    private let responseKey = "response"
    private let accessTokenKey = "access_token"
    private let errorKey = "error"
    
    //MARK: Authentication
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
        DispatchQueue.global(qos: .userInteractive).async {
            let authenticationService = AuthenticationService()
            authenticationService.authorization(with: UUID) {
                [weak self] (data, response, error) in
                guard error == nil else {
                    NotificationCenter.default.post(name: .AuthenticationPassedWithError, object: nil, userInfo: [self?.errorKey: error!])
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    NotificationCenter.default.post(name: .AuthenticationPassedWithError, object: nil, userInfo: [self?.errorKey: AuthenticationErrors.wrongResponse])
                    return
                }
                switch response.statusCode {
                case 200 ..< 300:
                    break
                default:
                    NotificationCenter.default.post(name: .AuthenticationPassedWithError, object: nil, userInfo: [self?.errorKey: AuthenticationErrors.badResponse(code: response.statusCode)])
                    return
                }
                guard let data = data,
                    self?.updateToken(with: data) ?? false else {
                         NotificationCenter.default.post(name: .AuthenticationPassedWithError, object: nil, userInfo: [self?.errorKey: AuthenticationErrors.wrongData])
                    return
                }
                NotificationCenter.default.post(name: .AuthenticationPassed, object: nil)
            }
        }
    }
    
    func logout() {
        KeychainWrapper.standard.removeObject(forKey: userDefaultsKey)
    }
    
    private func updateToken(with data: Data) -> Bool {
        guard let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let response = responseDictionary[responseKey] as? [String: Any],
            let newAccessToken = response[accessTokenKey] as? String else {
            return false
        }
        KeychainWrapper.standard.set(newAccessToken, forKey: userDefaultsKey)
        return true
    }
}
