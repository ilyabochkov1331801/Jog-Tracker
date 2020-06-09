//
//  Authentication.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

protocol Authentication {
    static var shared: Authentication { get }
    var accessToken: String? { get }
    var isAuthorized: Bool { get }
    func authorization(with UUID: String)
}
