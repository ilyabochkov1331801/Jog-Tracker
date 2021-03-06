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
    private let jogIconImageName = "jogIconImage"
    private let distanceLabelText = "Distance:"
    private let timeLabelText = "Time:"
    private let speedLabelText = "Speed:"
    private let timeLabelValueUnit = " min"
    private let distanceLabelValueUnit = " km"
    private let speedLabelValueUnit = " m/s"
    
    private var jogIconImageView: UIImageView!
    private var dateLabel: UILabel!
    private var distanceLabel: UILabel!
    private var distanceValueLabel: UILabel!
    private var timeLabel: UILabel!
    private var timeValueLabel: UILabel!
    private var speedLabel: UILabel!
    private var speedValueLabel: UILabel!
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        jogIconImageView = UIImageView()
        dateLabel = UILabel()
        distanceLabel = UILabel()
        distanceValueLabel = UILabel()
        timeLabel = UILabel()
        timeValueLabel = UILabel()
        speedLabel = UILabel()
        speedValueLabel = UILabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //MARK: JogIconImageView Settings
        contentView.addSubview(jogIconImageView)
        jogIconImageView.snp.makeConstraints {
            $0.height.equalTo(87)
            $0.width.equalTo(87)
            $0.left.equalTo(contentView).offset(66)
            $0.centerY.equalToSuperview()
        }
        jogIconImageView.image = UIImage(named: jogIconImageName)
        
        //MARK: DateLabel Settings
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(contentView).offset(20)
        }
        dateLabel.font = Fonts.cellDateLabelFont
        dateLabel.textColor = .gray
        
        //MARK: DistanceLabel and DistanceValueLabel Settings
        
        contentView.addSubview(distanceValueLabel)
        contentView.addSubview(distanceLabel)
        distanceLabel.snp.makeConstraints {
            $0.left.equalTo(contentView).offset(199)
            $0.centerY.equalTo(jogIconImageView)
        }
        distanceLabel.font = Fonts.cellLabelFont
        distanceLabel.text = distanceLabelText
        distanceValueLabel.snp.makeConstraints {
            $0.left.equalTo(distanceLabel.snp.right).offset(4)
            $0.centerY.equalTo(distanceLabel.snp.centerY)
        }
        distanceValueLabel.font = Fonts.cellLabelFont
        distanceValueLabel.textColor = .gray
        
        //MARK: TimeLabel and TimeValueLabel Settings
        
        contentView.addSubview(timeValueLabel)
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.left.equalTo(contentView).offset(199)
            $0.top.equalTo(distanceLabel.snp.bottom).offset(10)
        }
        timeLabel.font = Fonts.cellLabelFont
        timeLabel.text = timeLabelText
        timeValueLabel.snp.makeConstraints {
            $0.left.equalTo(timeLabel.snp.right).offset(4)
            $0.centerY.equalTo(timeLabel.snp.centerY)
        }
        timeValueLabel.font = Fonts.cellLabelFont
        timeValueLabel.textColor = .gray
        
        //MARK: SpeedLabel and SpeedValueLabel Settings
        
        contentView.addSubview(speedValueLabel)
        contentView.addSubview(speedLabel)
        speedLabel.snp.makeConstraints {
            $0.left.equalTo(contentView).offset(199)
            $0.bottom.equalTo(distanceLabel.snp.top).offset(-10)
        }
        speedLabel.font = Fonts.cellLabelFont
        speedLabel.text = speedLabelText
        speedValueLabel.snp.makeConstraints {
            $0.left.equalTo(speedLabel.snp.right).offset(4)
            $0.centerY.equalTo(speedLabel.snp.centerY)
        }
        speedValueLabel.font = Fonts.cellLabelFont
        speedValueLabel.textColor = .gray
    }
    
    func configurateCell(distance: Double, time: Int, fromDate: Date, toDate: Date) {
        distanceValueLabel.text = String(format: stringFormat, distance) + distanceLabelValueUnit
        timeValueLabel.text = String(time) + timeLabelValueUnit
        dateLabel.text = DateFormatters.weeklyReportTableViewCellDateFormatter.string(from: fromDate) + " - " + DateFormatters.weeklyReportTableViewCellDateFormatter.string(from: toDate)
        speedValueLabel.text = String(format: stringFormat, speed(time: time, distance: distance)) + speedLabelValueUnit
    }
    
    private func convert(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return DateFormatters.weeklyReportTableViewCellDateFormatter.string(from: date)
    }
    
    private func speed(time: Int, distance: Double) -> Double {
        let hoursTime = Double(time) / 60.0
        return distance / hoursTime
    }
    
}
