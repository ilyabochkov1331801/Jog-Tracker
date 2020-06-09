//
//  AuthenticationService.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class AuthenticationService {
    
    //MARK: URLs
    private let authenticationURL = "https://jogtracker.herokuapp.com/api/v1/auth/uuidLogin"
    
    //MARK: Constants
    private let post = "POST"
    private let uuidKey = "uuid"
    
    func authorization(with UUID: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard var urlComponents = URLComponents(string: authenticationURL) else {
            completionHandler(nil, nil, AuthenticationServiceErrors.urlError)
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: uuidKey, value: UUID)
        ]
        guard let url = urlComponents.url else {
            completionHandler(nil, nil, JogsServiceErrors.urlError)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = post
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
