//
//  UserService.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/12/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class UserService {
    
    private let userInfoURL = "https://jogtracker.herokuapp.com/api/v1/auth/user"
    private let accessTokenKey = "access_token"

    private let authentication: AuthenticationWithUUID = AuthenticationWithUUID.shared

    func loadUserInfo(completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let accessToken = authentication.accessToken else {
            completionHandler(nil, nil, UserServiceErrors.noAuthentication)
            return
        }
        guard var urlComponents = URLComponents(string: userInfoURL) else {
            completionHandler(nil, nil, UserServiceErrors.urlError)
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: accessTokenKey, value: accessToken)
        ]
        guard let url = urlComponents.url else {
            completionHandler(nil, nil, UserServiceErrors.urlError)
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: completionHandler).resume()
    }
}
