//
//  NotificationNameExtension.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

extension Notification.Name {
    public static let AuthenticationPassedWithError = NSNotification.Name("authenticationPassedWithError")
    public static let AuthenticationPassed = NSNotification.Name("authenticationPassed")
    public static let ReportFilterSettingsChanged = NSNotification.Name("ReportFilterSettingsChanged")
}
