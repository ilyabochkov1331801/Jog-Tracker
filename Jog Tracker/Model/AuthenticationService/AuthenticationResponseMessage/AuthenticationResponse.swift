//
//  AuthenticationResponse.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/24/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

struct AuthenticationResponse: Decodable {
    var access_token: String
}