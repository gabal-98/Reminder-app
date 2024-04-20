//
//  AddViewController.swift
//  project 4 ( Reminder )
//
//  Created by robusta on 20/04/2024.
//

import UIKit


class AddViewController: UIViewController {

    @IBOutlet var titleLabel: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var bodyLabel: UITextField!
    
    public var completion: ((String , String , Date) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveItem))
    }

    @objc func saveItem(){
        if let title = titleLabel.text{
            if let body = bodyLabel.text {
                let date = datePicker.date
                self.completion!(title , body , date)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}
