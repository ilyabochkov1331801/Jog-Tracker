//
//  NetworkingServiceErrors.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/24/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

enum NetworkingServiceErrors: Error {
    case nilResponse
    case badResponseStatus(code: Int)
    case nilData
    case decodingError
}
