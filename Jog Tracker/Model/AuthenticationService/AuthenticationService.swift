//
//  Authentication.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class AuthenticationService {
    
    static let shared: AuthenticationService = AuthenticationService()
    private init() { }
    
    private let authenticationApiDataManager = AuthenticationApiDataManager()
    private let authenticationKeychainDataManager = AuthenticationKeychainDataManager()
    
    var accessToken: String? {
        return authenticationKeychainDataManager.accessToken()
    }
    
    var isAuthorized: Bool {
        return accessToken != nil
    }
    
    func authorization(with UUID: String, completionHandler: @escaping (Result<Void, Error>) -> ()) {
        authenticationApiDataManager.authorization(with: UUID) {
            switch $0 {
            case .success(let newAccessToken):
                self.authenticationKeychainDataManager.updateToken(with: newAccessToken)
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func logout() {
        authenticationKeychainDataManager.logout()
    }
}
