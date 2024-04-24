//
//  DateViewController.swift
//  MemoApp
//
//  Created by Celes Augustus on 4/23/24.
//

import UIKit

protocol DateControllerDelegate: AnyObject {
    func didSelectDate(_ date: Date)
}

class DateViewController: UIViewController {
    weak var delegate: DateControllerDelegate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveDate))
                navigationItem.rightBarButtonItem = saveButton
        title = "Pick Date"
    }

    @objc func saveDate() {
        delegate?.didSelectDate(datePicker.date)
        navigationController?.popViewController(animated: true)
    }
}


