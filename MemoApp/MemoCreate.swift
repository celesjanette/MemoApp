//
//  MemoCreate.swift
//  MemoApp
//
//  Created by Celes Augustus on 4/23/24.
//

import UIKit
import CoreData

class MemoCreate: UIViewController, UITextFieldDelegate, DateControllerDelegate, UINavigationControllerDelegate{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var subjectField: UITextField!
    @IBOutlet weak var memoField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var criticalControl: UISegmentedControl!
    @IBOutlet weak var viewEditControl: UISegmentedControl!
    
    @IBOutlet weak var addDateButton: UIButton!
    
    var currentMemo: Memo?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        
        viewEditControl.selectedSegmentIndex = 0
        updateViewEditState()
       
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func viewEditControlChange(_ sender: UISegmentedControl) {
        updateViewEditState()
        
    }
        func updateViewEditState(){
            if viewEditControl.selectedSegmentIndex == 0 { // view mode
                subjectField.isEnabled = false
                memoField.isEnabled = false
                addDateButton.isEnabled = false
                criticalControl.isEnabled = false
                navigationItem.rightBarButtonItem = nil
            } else { // edit mode
                subjectField.isEnabled = true
                memoField.isEnabled = true
                addDateButton.isEnabled = true
                criticalControl.isEnabled = true
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveMemo))
                        }
        }
    @IBAction func addDate(_ sender: Any) {
           performSegue(withIdentifier: "segueDate", sender: self)
       }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDate" {
            if let dateController = segue.destination as? DateViewController {
                dateController.delegate = self
            }
        }
    }
    func didSelectDate(_ date: Date) {
        if currentMemo == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentMemo = Memo(context: context)
        }
      
        currentMemo?.date = date
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            dateLabel.text = formatter.string(from: date)
        }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
        }
    
        @objc func saveMemo() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let context = appDelegate.persistentContainer.viewContext
                
                if let existingMemo = currentMemo {
                    existingMemo.subject = subjectField.text
                    existingMemo.memoArea = memoField.text
                   
                    if let selectedDate = currentMemo?.date {
                        existingMemo.date = selectedDate
                    }
                    
                    switch criticalControl.selectedSegmentIndex {
                    case 0:
                        existingMemo.criticality = 1
                    case 1:
                        existingMemo.criticality = 2
                    case 2:
                        existingMemo.criticality = 3
                    default:
                        existingMemo.criticality = 0
                    }
                } else {
                    let newMemo = Memo(context: context)
                    
                    newMemo.subject = subjectField.text
                    newMemo.memoArea = memoField.text
                    
                    
                    if let selectedDate = currentMemo?.date {
                        newMemo.date = selectedDate
                    } else {
                        newMemo.date = Date()
                    }
                    
                    switch criticalControl.selectedSegmentIndex {
                    case 0:
                        newMemo.criticality = 1
                    case 1:
                        newMemo.criticality = 2
                    case 2:
                        newMemo.criticality = 3
                    default:
                        newMemo.criticality = 0
                    }
                    
                    currentMemo = newMemo
                }
                
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Could not save memo. \(error), \(error.userInfo)")
                }
                
                viewEditControl.selectedSegmentIndex = 0
                updateViewEditState()
            }
   
}
