//
//  AuthenticationApiDataManager.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/25/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class AuthenticationApiDataManager: ApiDataManager {
    
    func authorization(with UUID: String, completionHandler: @escaping (Result<String, Error>) -> ()) {
        guard let request = ApiRequest.authenticationApiRequest(with: UUID) else {
            completionHandler(.failure(ApiDataManagerErrors.nilRequest))
            return
        }
        
        super.makeURLRequest(with: request) { (result: Result<AuthenticationResponseMessage, Error>) in
            switch result {
                case .success(let newAuthenticationResponseMessage):
                    completionHandler(.success(newAuthenticationResponseMessage.response.accessToken))
            case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
    
}
