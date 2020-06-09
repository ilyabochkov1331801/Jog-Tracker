//
//  CustomTableViewCell.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    private let stringFormat = "%.1f"
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configurateCell(distance: Double, times: Int, date: Int) {
        distanceLabel.text = String(format: stringFormat, distance)
        timesLabel.text = String(times)
        dateLabel.text = convert(timeInterval: date)
    }
    
    private func convert(timeInterval: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let date = Date(timeIntervalSince1970: Double(timeInterval))
        return dateFormatter.string(from: date)
    }
}
