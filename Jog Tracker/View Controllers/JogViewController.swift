//
//  JogViewController.swift
//  Jog Tracker
//
//  Created by Илья Бочков  on 6/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class JogViewController: UIViewController {

    @IBOutlet weak var distanceTextFiled: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private let controllerTitle = "Your jog"
    private var jog: Jog?
    var delegate: JogViewControllerDelegate?
    
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
        
        title = controllerTitle
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(save))
        if let jog = jog {
            distanceTextFiled.text = String(jog.distance)
            timeTextField.text = String(jog.time)
            datePicker.date = Date(timeIntervalSince1970: TimeInterval(jog.date))
        } else {
            datePicker.date = Date()
        }
        datePicker.maximumDate = Date()
        
        timeTextField.delegate = self
        distanceTextFiled.delegate = self
    }
    
    @objc func save() {
        let jogs = JogsService.shared
        guard let timeString = timeTextField.text,
            let time = Int(timeString),
            let distanceString = distanceTextFiled.text,
            let distance = Double(distanceString) else {
                return
        }
        if let jog = jog {
            let newJog = Jog(id: jog.id,
                             userId: jog.userId,
                             distance: distance,
                             time: time,
                             date: datePicker.date.timeIntervalSince1970)
            jogs.update(jog: newJog) {
                [weak self] (result) in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(()):
                    self.delegate?.updateData()
                case .failure(let error):
                    self.alertConfiguration(with: error)
                }
            }
        } else {
            jogs.add(date: datePicker.date, time: time, distance: distance) {
                [weak self] (result) in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(()):
                    self.delegate?.updateData()
                case .failure(let error):
                    self.alertConfiguration(with: error)
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

extension JogViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
