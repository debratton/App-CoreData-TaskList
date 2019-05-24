//
//  AddItemVC.swift
//  TaskList
//
//  Created by David E Bratton on 5/20/19.
//  Copyright © 2019 David Bratton. All rights reserved.
//

import UIKit

protocol AddNewItem {
    func addItem(item: Item)
}

class AddItemVC: UIViewController {

    @IBOutlet weak var itemNameLabel: UITextField!
    @IBOutlet weak var importantSwitch: UISwitch!
    @IBOutlet weak var completedSwitch: UISwitch!
    
    var passedItem: Item?
    var mode = ""
    var delegate: AddNewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if mode == "Edit" {
            self.title = "Edit - Item"
        }
        print("\(mode)")
        print(passedItem ?? "Nothing passed")
        
        if let editItem = passedItem {
            itemNameLabel.text = editItem.name
            if editItem.important == true {
                importantSwitch.isOn = true
            } else {
                importantSwitch.isOn = false
            }
            
            if editItem.completed == true {
                completedSwitch.isOn = true
            } else {
                completedSwitch.isOn = false
            }
        }
    }
    
    func presentAlert(alert:String) {
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func saveItemBtnPressed(_ sender: UIBarButtonItem) {
        if mode == "Edit" {
            if itemNameLabel.text != "" {
                passedItem!.name = itemNameLabel.text
                passedItem!.important = importantSwitch.isOn
                passedItem!.completed = completedSwitch.isOn
                Helper.saveCD()
                navigationController?.popViewController(animated: true)
            } else {
                presentAlert(alert: "Item Name is Required!")
            }
        } else {
            if itemNameLabel.text != "" {
                if let name = itemNameLabel.text {
                    let newItem = Item(context: Helper.context)
                    newItem.name = name
                    newItem.important = importantSwitch.isOn
                    newItem.completed = completedSwitch.isOn
                    delegate.addItem(item: newItem)
                    navigationController?.popViewController(animated: true)
                }
            } else {
                presentAlert(alert: "Item Name is Required!")
            }
        }
    }
    
}
