//
//  Helper.swift
//  TaskList
//
//  Created by David E Bratton on 5/19/19.
//  Copyright © 2019 David Bratton. All rights reserved.
//

import UIKit
import CoreData

class Helper {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func saveCD() {
        do {
            try context.save()
        } catch {
            print("Error saving CD: \(error.localizedDescription)")
        }
    }
    
    // [c] and [d] => [cd] to remove case sensitive and dialect specific
    static func searchCategories(searchString: String) -> [Category]? {
        var fetchCategories = [Category]()
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        if searchString != "" {
            let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchString)
            let sortByName = NSSortDescriptor(key: "name", ascending: true)
            let sortDescriptors = [sortByName]
            request.sortDescriptors = sortDescriptors
            request.predicate = predicate
        } else {
            let sortByName = NSSortDescriptor(key: "name", ascending: true)
            let sortDescriptors = [sortByName]
            request.sortDescriptors = sortDescriptors
        }
        do {
            fetchCategories = try context.fetch(request)
        } catch {
            print("Error retrieving CD: \(error.localizedDescription)")
        }
        
        return fetchCategories
    }
    
    // [c] and [d] => [cd] to remove case sensitive and dialect specific
    static func searchItems(passedCategory: String, searchString: String) -> [Item]? {
        var fetchItems = [Item]()
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate1 = NSPredicate(format: "category.name MATCHES[cd] %@", passedCategory)
        if searchString != "" {
            let predicate2 = NSPredicate(format: "name CONTAINS[cd] %@", searchString)
            let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
            let sortByName = NSSortDescriptor(key: "name", ascending: true)
            let sortDescriptors = [sortByName]
            request.sortDescriptors = sortDescriptors
            request.predicate = compound
        } else {
            let sortByName = NSSortDescriptor(key: "name", ascending: true)
            let sortDescriptors = [sortByName]
            request.sortDescriptors = sortDescriptors
            request.predicate = predicate1
        }
        do {
            fetchItems = try context.fetch(request)
        } catch {
            print("Error retrieving CD: \(error.localizedDescription)")
        }
        return fetchItems
    }
}
