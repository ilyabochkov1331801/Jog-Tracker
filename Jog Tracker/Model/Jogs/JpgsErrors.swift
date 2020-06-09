//
//  JpgsErrors.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

enum JogsErrors: Error {
    case wrongResponse
    case badResponse(code: Int)
}