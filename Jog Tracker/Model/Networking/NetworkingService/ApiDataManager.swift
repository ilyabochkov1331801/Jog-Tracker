//
//  NetworkingService.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/24/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class ApiDataManager {
    
    func makeURLRequest<T: Decodable>(with request: URLRequest, completionHandler: @escaping (Result<T, Error>) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                DispatchQueue.main.async {
                    guard error == nil else  {
                        completionHandler(.failure(error!))
                        return
                    }
                    guard let response = response as? HTTPURLResponse else {
                        completionHandler(.failure(ApiDataManagerErrors.nilResponse))
                        return
                    }
                    switch response.statusCode {
                    case 200 ..< 300:
                        break
                    default:
                        completionHandler(.failure(ApiDataManagerErrors.badResponseStatus(code: response.statusCode)))
                        return
                    }
                    guard let data = data else {
                        completionHandler(.failure(ApiDataManagerErrors.nilData))
                        return
                    }
                    guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                        completionHandler(.failure(ApiDataManagerErrors.decodingError))
                        return
                    }
                    completionHandler(.success(decodedData))
                }
            }.resume()
        }
    }
}
