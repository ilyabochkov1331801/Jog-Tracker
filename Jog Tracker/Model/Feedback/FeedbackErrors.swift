//
//  FeedbackErrors.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

enum FeedbackErrors: Error {
    case wrongResponse
    case badResponse(code: Int)
}
