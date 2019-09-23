//
//  ViewController.swift
//  18_Todoey
//
//  Created by Barbara Joseph on 10/09/2019.
//  Copyright © 2019 Gehertt. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray: [Item] = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // print the location for data storage on this phone
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        searchBar.delegate = self

        //loadItems()
        
    }
    
    
    // MARK: - Table view Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //toggle checkmark
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    // MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
 // MARK - Add New items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert: UIAlertController = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            // what will happen once user clicks "Add Item" btn on UIAlert
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK - Data Manipulation Methods
    
    func saveItems() {
//        commit our context to permanent storage inside persistentContainer. xfer data from context
//        (staging area) to perm. storage (pers..Container)
        do {
           try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadItems(requestSubmitted requestReceived : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // optionalBinding to check argPredicate is not nil before adding to compoundPredicate
        if let additionalPredicate = predicate {
            requestReceived.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else {
            requestReceived.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(requestReceived)
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    

}

// MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // for all items, return ones where title contains searchBar text
         let predicate = NSPredicate(format: "done EQUALS[cd] %@", searchBar.text!)
        
        // create sort descriptor & append to the request
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(requestSubmitted: request, predicate: predicate)
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            // curser gone from searchBar
            // do this on th main thread
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
    
    

    
}

