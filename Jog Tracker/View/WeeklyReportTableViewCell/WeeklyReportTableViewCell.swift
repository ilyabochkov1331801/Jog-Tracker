//
//  WeeklyReportTableViewCell.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class WeeklyReportTableViewCell: UITableViewCell {

    private let stringFormat = "%.1f"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var allTimeLabel: UILabel!
    @IBOutlet weak var allDistanceLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configurateCell(weaklyReport: WeaklyReport) {
        dateLabel.text = dateFormatter.string(from: weaklyReport.beginOfWeek) + " - " + dateFormatter.string(from: weaklyReport.endOfWeek)
        allTimeLabel.text = String(weaklyReport.allTime)
        allDistanceLabel.text = String(weaklyReport.allDistance)
        averageSpeedLabel.text = String(format: stringFormat, weaklyReport.avaregeSpeed)
    }
    
}
