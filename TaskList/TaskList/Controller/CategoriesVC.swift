//
//  CategoriesVC.swift
//  TaskList
//
//  Created by David E Bratton on 5/19/19.
//  Copyright © 2019 David Bratton. All rights reserved.
//

import UIKit

class CategoriesVC: UITableViewController {

    @IBOutlet weak var searchBarBtn: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categorySwitch: UISwitch!
    
    //MARK: Array
    var categories = [Category]()
    var searchController = UISearchController(searchResultsController: nil)
    var buttonTapped = "Categories"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = ""
        loadCategories(searchString: "")
    }
    
    func loadCategories(searchString: String) {
        if let fetchedCategories = Helper.searchCategories(searchString: searchString) {
            categories = fetchedCategories
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Mode: \(buttonTapped)"
        label.textColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        headerView.addSubview(label)
        
        return headerView
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCategory: Category
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        
        if categories[indexPath.row].completed == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        currentCategory = categories[indexPath.row]
        cell.configureCell(category: currentCategory)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let categoryToDelete = categories[indexPath.row]
            Helper.context.delete(categoryToDelete)
            Helper.saveCD()
            loadCategories(searchString: "")
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if buttonTapped == "Categories" {
            let selectedCategory = categories[indexPath.row]
            performSegue(withIdentifier: "UpdateCategory", sender: selectedCategory)
            searchController.isActive = false
        }
        
        if buttonTapped == "Items"  {
            let selectedCategory = categories[indexPath.row]
            performSegue(withIdentifier: "AddItem", sender: selectedCategory)
            searchController.isActive = false
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpdateCategory" {
            if let destinationVC = segue.destination as? AddCategoryVC {
                let mode = "Edit"
                destinationVC.mode = mode
                if let passedCategory = sender as? Category {
                    destinationVC.passedCategory = passedCategory
                }
            }
        }
        
        if segue.identifier == "AddItem" {
            if let destinationVC = segue.destination as? ItemsVC {
                if let passedCategory = sender as? Category {
                    destinationVC.passedCategory = passedCategory
                }
            }
        }
    }
    
    @IBAction func categorySwitchPressed(_ sender: UISwitch) {
        if categorySwitch.isOn == true {
            buttonTapped = "Categories"
            tableView.reloadData()
        } else {
            buttonTapped = "Items"
            tableView.reloadData()
        }
    }
    
    @IBAction func searchBarBtnPressed(_ sender: UIBarButtonItem) {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Categories..."
        definesPresentationContext = true
        self.present(searchController, animated: true, completion: nil)
    }
}

extension CategoriesVC: UISearchBarDelegate, UISearchResultsUpdating, SetSwitchState {
    func changeImportantSwitch(_ sender: CategoryCell, isOn: Bool) {
        let indexPath = self.tableView.indexPath(for: sender)
        let category = categories[indexPath!.row]
        if isOn == true {
            category.important = true
        } else {
            category.important = false
        }
        Helper.saveCD()
        loadCategories(searchString: "")
    }
    
    func changeDoneSwitch(_ sender: CategoryCell, isOn: Bool) {
        let indexPath = self.tableView.indexPath(for: sender)
        let category = categories[indexPath!.row]
        if isOn == true {
            category.completed = true
        } else {
            category.completed = false
        }
        Helper.saveCD()
        loadCategories(searchString: "")
    }
    
    //MARK: Search Button
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if searchText.count == 0 {
                loadCategories(searchString: "")
                DispatchQueue.main.async {
                    searchController.resignFirstResponder()
                }
            } else {
                if let searchText = searchController.searchBar.text {
                    loadCategories(searchString: searchText)
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            loadCategories(searchString: searchText)
        }
    }
    
    //MARK: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchString = searchBar.text {
            if searchString.count == 0 {
                loadCategories(searchString: "")
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            } else {
                if let searchText = searchBar.text {
                    loadCategories(searchString: searchText)
                }
            }
        }
    }
}

