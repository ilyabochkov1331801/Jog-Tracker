//
//  WeeklyReportTableViewCell.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit
import SnapKit

class WeeklyReportTableViewCell: UITableViewCell {

    private let stringFormat = "%.1f"
    
    var jogIconImageView: UIImageView!
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        jogIconImageView = UIImageView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addSubview(jogIconImageView)
        jogIconImageView.snp.makeConstraints {
            (make) in
            make.height.size.equalTo(87)
            make.width.size.equalTo(87)
            make.left.equalTo(contentView).offset(66)
            make.centerY.equalToSuperview()
        }
    }
    
    func configurateCell(weaklyReport: WeaklyReport) {
//        dateLabel.text = dateFormatter.string(from: weaklyReport.beginOfWeek) + " - " + dateFormatter.string(from: weaklyReport.endOfWeek)
//        allTimeLabel.text = String(weaklyReport.allTime)
//        allDistanceLabel.text = String(weaklyReport.allDistance)
//        averageSpeedLabel.text = String(format: stringFormat, weaklyReport.avaregeSpeed)
    }
    
}
