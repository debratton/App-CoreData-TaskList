//
//  ItemsVC.swift
//  TaskList
//
//  Created by David E Bratton on 5/20/19.
//  Copyright © 2019 David Bratton. All rights reserved.
//

import UIKit

class ItemsVC: UITableViewController {

    @IBOutlet weak var searchBarBtn: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var items = [Item]()
    var passedCategory: Category?
    var buttonTapped = "UpdateItem"
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = passedCategory?.name {
            print("ItemsVC: \(name)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = ""
        loadItems(searchString: "")
    }
    
    func loadItems(searchString: String) {
        if let passedName = passedCategory?.name {
            if let fetchedItems = Helper.searchItems(passedCategory: passedName, searchString: searchString){
                items = fetchedItems
                tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func searchBarBtnPressed(_ sender: UIBarButtonItem) {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Categories..."
        definesPresentationContext = true
        self.present(searchController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        if let name = passedCategory?.name {
            label.text = "Category: \(name)"
        }
        label.textColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        headerView.addSubview(label)
        
        return headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem: Item
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
        
        if items[indexPath.row].completed == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        currentItem = items[indexPath.row]
        cell.configureCell(item: currentItem)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = items[indexPath.row]
            Helper.context.delete(itemToDelete)
            Helper.saveCD()
            loadItems(searchString: "")
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        performSegue(withIdentifier: "UpdateItem", sender: selectedItem)
        searchController.isActive = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpdateItem" {
            if let destinationVC = segue.destination as? AddItemVC {
                let mode = "Edit"
                destinationVC.mode = mode
                if let passedItem = sender as? Item {
                    destinationVC.passedItem = passedItem
                }
            }
        }
        
        if segue.identifier == "AddNewItem" {
            if let destinationVC = segue.destination as? AddItemVC {
                destinationVC.delegate = self
            }
        }
    }
}

extension ItemsVC: UISearchBarDelegate, UISearchResultsUpdating, SetItemSwitchState, AddNewItem {
    func addItem(item: Item) {
        item.category = passedCategory
        Helper.saveCD()
        loadItems(searchString: "")
    }
    
    func changeImportantSwitch(_ sender: ItemCell, isOn: Bool) {
        let indexPath = self.tableView.indexPath(for: sender)
        let item = items[indexPath!.row]
        if isOn == true {
            item.important = true
        } else {
            item.important = false
        }
        Helper.saveCD()
        loadItems(searchString: "")
    }
    
    func changeCompletedSwitch(_ sender: ItemCell, isOn: Bool) {
        let indexPath = self.tableView.indexPath(for: sender)
        let item = items[indexPath!.row]
        if isOn == true {
            item.completed = true
        } else {
            item.completed = false
        }
        Helper.saveCD()
        loadItems(searchString: "")
    }
    
    //MARK: Search Button
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if searchText.count == 0 {
                loadItems(searchString: "")
                DispatchQueue.main.async {
                    searchController.resignFirstResponder()
                }
            } else {
                if let searchText = searchController.searchBar.text {
                    loadItems(searchString: searchText)
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            loadItems(searchString: searchText)
        }
    }
    
    //MARK: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchString = searchBar.text {
            if searchString.count == 0 {
                loadItems(searchString: "")
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            } else {
                if let searchText = searchBar.text {
                    loadItems(searchString: searchText)
                }
            }
        }
    }
}
