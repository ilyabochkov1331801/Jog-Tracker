//
//  NetworkingService.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/24/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class NetworkingService <T: Decodable> {
    
    func makeURLRequest(with request: URLRequest, completionHandler: @escaping (Result<T, Error>) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                guard error == nil else  {
                    DispatchQueue.main.async {
                        completionHandler(.failure(error!))
                    }
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completionHandler(.failure(NetworkingServiceErrors.nilResponse))
                    }
                    return
                }
                switch response.statusCode {
                case 200 ..< 300:
                    break
                default:
                    DispatchQueue.main.async {
                        completionHandler(.failure(NetworkingServiceErrors.badResponseStatus(code: response.statusCode)))
                    }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        completionHandler(.failure(NetworkingServiceErrors.nilData))
                    }
                    return
                }
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    DispatchQueue.main.async {
                        completionHandler(.failure(NetworkingServiceErrors.decodingError))
                    }
                    return
                }
                DispatchQueue.main.async {
                    completionHandler(.success(decodedData))
                }
            }.resume()
        }
    }
}
