//
//  AuthenticationService.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class AuthenticationService {
    
    private let authenticationURL = "https://jogtracker.herokuapp.com/api/v1/auth/uuidLogin"
    
    func authorization(with UUID: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let url = URL(string: authenticationURL + "?uuid=\(UUID)") else {
            completionHandler(nil, nil, AuthenticationServiceErrors.urlError)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
