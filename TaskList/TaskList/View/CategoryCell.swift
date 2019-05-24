//
//  CategoryCell.swift
//  TaskList
//
//  Created by David E Bratton on 5/21/19.
//  Copyright © 2019 David Bratton. All rights reserved.
//

import UIKit

protocol SetSwitchState {
    func changeImportantSwitch(_ sender: CategoryCell, isOn: Bool)
    func changeDoneSwitch(_ sender: CategoryCell, isOn: Bool)
}

class CategoryCell: UITableViewCell {

    var delegate: SetSwitchState!

    @IBOutlet weak var importantLabel: UILabel!
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var importantSwitch: UISwitch!
    @IBOutlet weak var doneSwitch: UISwitch!
    @IBAction func importantSwitchPressed(_ sender: UISwitch) {
        delegate.changeImportantSwitch(self, isOn: importantSwitch.isOn)
    }
    
    @IBAction func doneSwitchPressed(_ sender: UISwitch) {
        delegate.changeDoneSwitch(self, isOn: doneSwitch.isOn)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(category: Category) {
        if let name = category.name {
            if category.important == true {
                taskLabel.text = "\(name)❗️"
            } else {
                taskLabel.text = "\(name)"
            }
        }
        
        if category.important == true {
            importantSwitch.isOn = true
        } else {
            importantSwitch.isOn = false
        }

        if category.completed == true {
            doneSwitch.isOn = true
        } else {
            doneSwitch.isOn = false
        }
    }
}
