//
//  User.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/12/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class User {
    
    private let responseKey = "response"
    private let firstNameKey = "first_name"
    private let lastNameKey = "last_name"
    private let phoneKey = "phone"
    private let emailKey = "email"
    
    var firstName: String = ""
    var lastName: String = ""
    var phone: String = ""
    var email: String = ""
    
    func loadUserInfo() {
        let userService = UserService()
        userService.loadUserInfo {
            [weak self] (data, response, error) in
            guard error == nil else {
                return
            }
            guard let response = response as? HTTPURLResponse else {
                return
            }
            switch response.statusCode {
            case 200 ..< 300:
                break
            default:
                return
            }
            guard let data = data,
                let _ = self?.update(with: data) else {
                return
            }
            NotificationCenter.default.post(name: .UserInfoLoaded, object: nil)
        }
    }
    
    private func update(with data: Data) -> Bool {
        guard let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let response = responseDictionary[responseKey] as? [String: Any],
            let firstName = response[firstNameKey] as? String,
            let lastName = response[lastNameKey] as? String,
            let email = response[emailKey] as? String,
            let phone = response[phoneKey] as? String else {
                return false
        }
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        return true
    }
}
