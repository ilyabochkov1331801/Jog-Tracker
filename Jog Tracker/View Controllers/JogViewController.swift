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
        let jogs = Jogs.shared
        guard let timeString = timeTextField.text,
            let time = Int(timeString),
            let distanceString = distanceTextFiled.text,
            let distance = Double(distanceString) else {
                return
        }
        if var jog = jog {
            jog.date = datePicker.date.timeIntervalSince1970
            jog.distance = distance
            jog.time = time
            jogs.append(newJog: jog)
        } else {
            jogs.append(date: datePicker.date, time: time, distance: distance)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension JogViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
