//
//  Authentication.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class AuthenticationWithUUID {
    
    //MARK: Singletone
    static var shared: AuthenticationWithUUID = AuthenticationWithUUID()
    private init() { }
    
    //MARK: Constants
    private let userDefaultsKey = "accessToken"
    private let authenticationURL = "https://jogtracker.herokuapp.com/api/v1/auth/uuidLogin"
    private let post = "POST"
    private let uuidKey = "uuid"
    
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
    
    func authorization(with UUID: String, completionHandler: @escaping (Result<Void, Error>) -> ()) {
        guard var urlComponents = URLComponents(string: authenticationURL) else {
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: uuidKey, value: UUID)
        ]
        guard let url = urlComponents.url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = post
        
        let networkingService = NetworkingService<AuthenticationResponseMessage>()
        networkingService.makeURLRequest(with: request) {
            (result) in
            switch result {
            case .success(let newAuthenticationResponseMessage):
                let newAccessToken = newAuthenticationResponseMessage.response.access_token
                self.updateToken(with: newAccessToken)
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func logout() {
        KeychainWrapper.standard.removeObject(forKey: userDefaultsKey)
    }
    
    private func updateToken(with newAccessToken: String) {
        KeychainWrapper.standard.set(newAccessToken, forKey: userDefaultsKey)
    }
}
