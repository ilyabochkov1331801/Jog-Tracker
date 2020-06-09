//
//  feedbackDelegate.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

protocol FeedbackDelegate {
    func feedbackWasPosted()
    func feedbackWasCancel(with error: Error)
}
