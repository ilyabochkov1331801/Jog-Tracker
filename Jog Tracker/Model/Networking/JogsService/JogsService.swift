//
//  JogsService.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class JogsService {
    
    private let loadAllJogsURL = "https://jogtracker.herokuapp.com/api/v1/data/sync"
    private let authentication = AuthenticationWithUUID.shared
    
    func loadJogsList(completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let accessToken = authentication.accessToken else {
            completionHandler(nil, nil, JogsServiceErrors.noAuthentication)
            return
        }
        guard let url = URL(string: loadAllJogsURL + "?access_token=\(accessToken)") else {
            completionHandler(nil, nil, JogsServiceErrors.urlError)
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: completionHandler).resume()
    }
}
