//
//  AddCategoryVC.swift
//  TaskList
//
//  Created by David E Bratton on 5/19/19.
//  Copyright © 2019 David Bratton. All rights reserved.
//

import UIKit

class AddCategoryVC: UIViewController {

    @IBOutlet weak var categoryNameText: UITextField!
    @IBOutlet weak var importantSwitch: UISwitch!
    @IBOutlet weak var completedSwitch: UISwitch!
    
    var passedCategory: Category?
    var mode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if mode == "Edit" {
            self.title = "Edit - Category"
        }
        if let editCategory = passedCategory {
            categoryNameText.text = editCategory.name
            if editCategory.important == true {
                importantSwitch.isOn = true
            } else {
                importantSwitch.isOn = false
            }
            
            if editCategory.completed == true {
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
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        if mode == "Edit" {
            if categoryNameText.text != "" {
                passedCategory!.name = categoryNameText.text
                passedCategory!.important = importantSwitch.isOn
                passedCategory!.completed = completedSwitch.isOn
                Helper.saveCD()
                navigationController?.popViewController(animated: true)
            } else {
                presentAlert(alert: "Category Name is Required!")
            }
        } else {
            if categoryNameText.text != "" {
                if let name = categoryNameText.text {
                    let newCategory = Category(context: Helper.context)
                    newCategory.name = name
                    newCategory.important = importantSwitch.isOn
                    newCategory.completed = completedSwitch.isOn
                    Helper.saveCD()
                    navigationController?.popViewController(animated: true)
                }
            } else {
                presentAlert(alert: "Category Name is Required!")
            }
        }
    }
}
