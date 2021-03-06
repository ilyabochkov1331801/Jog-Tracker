//
//  JogViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit
import SnapKit

class JogViewController: UIViewController {
    
    private let buttonTextLabelText = "Save"
    private let closeImageName = "closeImage"
    private let timeLabelText = "Time"
    private let distanceLabelText = "Distance"
    private let dateLabelText = "Date"
    
    private var jog: Jog?
    var delegate: JogViewControllerDelegate?
    private lazy var completionHandler: (Result<Void, Error>) -> () = {
        [weak self] (result) in
        guard let self = self else {
            return
        }
        switch result {
        case .success(()):
            self.delegate?.updateData()
            self.navigationController?.popViewController(animated: true)
        case .failure(let error):
            self.alertConfiguration(with: error)
        }
    }
    
    private var navigationBarView: UIView!
    private var logoImageView: UIImageView!
    private var distanceTextFiled: UITextField!
    private var timeTextField: UITextField!
    private var dateTextField: UITextField!
    private var contentView: UIView!
    private var saveButton: UIButton!
    private var buttonTextLabel: UILabel!
    private var closeButton: UIButton!
    private var dateLabel: UILabel!
    private var timeLabel: UILabel!
    private var distanceLabel: UILabel!
    
    init(newJog: Jog) {
        super.init(nibName: nil, bundle: nil)
        self.jog = newJog
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarView = UIView()
        logoImageView = UIImageView()
        distanceTextFiled = UITextField()
        timeTextField = UITextField()
        dateTextField = UITextField()
        contentView = UIView()
        saveButton = UIButton()
        buttonTextLabel = UILabel()
        closeButton = UIButton()
        timeLabel = UILabel()
        dateLabel = UILabel()
        distanceLabel = UILabel()
        
        timeTextField.delegate = self
        dateTextField.delegate = self
        distanceTextFiled.delegate = self
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
                        
        view.backgroundColor = .white
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeDown.direction = .down
        swipeDown.delegate = self
        view.addGestureRecognizer(swipeDown)
        
        if let jog = jog {
            distanceTextFiled.text = String(jog.distance)
            timeTextField.text = String(jog.time)
            dateTextField.text = DateFormatters.jogVCDateFormatter.string(from: Date(timeIntervalSince1970: jog.date))
        } else {
            dateTextField.text = DateFormatters.jogVCDateFormatter.string(from: Date())
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //MARK: ContentView Settings
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalTo(view).inset(UIEdgeInsets(top: 159, left: 34, bottom: 128, right: 34))
        }
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = Colors.appGreen
        
        //MARK: SaveButton Settings
        
        contentView.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.edges.equalTo(contentView).inset(UIEdgeInsets(top: 301, left: 35, bottom: 37, right: 35))
        }
        saveButton.layer.cornerRadius = 20
        saveButton.layer.borderColor = UIColor.white.cgColor
        saveButton.layer.borderWidth = 2
        
        //MARK: ButtonTextLabel Settings
        
        saveButton.addSubview(buttonTextLabel)
        buttonTextLabel.snp.makeConstraints {
            $0.centerX.equalTo(saveButton)
            $0.centerY.equalTo(saveButton)
        }
        buttonTextLabel.text = buttonTextLabelText
        buttonTextLabel.textColor = .white
        buttonTextLabel.textAlignment = .center
        buttonTextLabel.font = Fonts.jogVCButtonTextLabelFont
        
        //MARK: DateTextFiled Settings
        
        contentView.addSubview(dateTextField)
        dateTextField.snp.makeConstraints {
            $0.edges.equalTo(contentView).inset(UIEdgeInsets(top: 229, left: 35, bottom: 120, right: 35))
        }
        dateTextField.borderStyle = .roundedRect
        dateTextField.backgroundColor = .white
        
        //MARK: TimeTextFiled Settings
        
        contentView.addSubview(timeTextField)
        timeTextField.snp.makeConstraints {
            $0.edges.equalTo(contentView).inset(UIEdgeInsets(top: 157, left: 35, bottom: 192, right: 35))
        }
        timeTextField.borderStyle = .roundedRect
        timeTextField.backgroundColor = .white
        
        //MARK: DateTextFiled Settings
        
        contentView.addSubview(distanceTextFiled)
        distanceTextFiled.snp.makeConstraints {
            $0.edges.equalTo(contentView).inset(UIEdgeInsets(top: 85, left: 35, bottom: 264, right: 35))
        }
        distanceTextFiled.borderStyle = .roundedRect
        distanceTextFiled.backgroundColor = .white
        
        //MARK: CloseButton Settings
        
        contentView.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.edges.equalTo(contentView).inset(UIEdgeInsets(top: 19, left: 268, bottom: 342, right: 21))
        }
        closeButton.setImage(UIImage(named: closeImageName), for: .normal)
        
        //MARK: TimeLabel Settings
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            //$0.edges.equalTo(contentView).inset(UIEdgeInsets(top: 136, left: 38, bottom: 229, right: 215))
            $0.left.equalTo(contentView).offset(38)
            $0.top.equalTo(contentView).offset(136)
        }
        timeLabel.text = timeLabelText
        timeLabel.font = Fonts.jogVCLabelFont
        
        //MARK: DistanceLabel Settings
        
        contentView.addSubview(distanceLabel)
        distanceLabel.snp.makeConstraints {
            //$0.edges.equalTo(contentView).inset(UIEdgeInsets(top: 64, left: 38, bottom: 301, right: 200))
            $0.left.equalTo(contentView).offset(38)
            $0.top.equalTo(contentView).offset(64)
        }
        distanceLabel.text = distanceLabelText
        distanceLabel.font = Fonts.jogVCLabelFont
        
        //MARK: DateLabel Settings
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            //$0.edges.equalTo(contentView).inset(UIEdgeInsets(top: 208, left: 38, bottom: 157, right: 215))
            $0.left.equalTo(contentView).offset(38)
            $0.top.equalTo(contentView).offset(208)
        }
        dateLabel.text = dateLabelText
        dateLabel.font = Fonts.jogVCLabelFont
        
        //MARK: NavigationBarView Settings
        
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints {
            $0.width.equalTo(view.snp.width)
            $0.height.equalTo(77)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalTo(view.snp.centerX)
        }
        navigationBarView.backgroundColor = Colors.appGreen
        
        //MARK: LogoImageView Settings
        
        navigationBarView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.edges.equalTo(navigationBarView).inset(UIEdgeInsets(top: 20, left: 25, bottom: 20, right: 252))
        }
        logoImageView.image = UIImage(named: ImageName.logoImageName)
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func save() {
        let jogsService = JogsService.shared
        guard let timeString = timeTextField.text,
            let time = Int(timeString),
            let distanceString = distanceTextFiled.text,
            let distance = Double(distanceString),
            let dateString = dateTextField.text,
            let date = DateFormatters.jogVCDateFormatter.date(from: dateString) else {
                return
        }
        if let jog = jog {
            let newJog = Jog(id: jog.id,
                             userId: jog.userId,
                             distance: distance,
                             time: time,
                             date: date.timeIntervalSince1970)
            jogsService.update(jog: newJog, completionHandler: completionHandler)
        } else {
            jogsService.add(date: date, time: time, distance: distance, completionHandler: completionHandler)
        }
    }
}

extension JogViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension JogViewController: UIGestureRecognizerDelegate {
    
}
