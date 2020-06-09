//
//  JogsDelegate.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

protocol JogsDelegate {
    func updatingDataDidFinished()
    func updatingDataDidFinished(with error: Error)
}
