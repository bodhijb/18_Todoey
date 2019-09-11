//
//  ViewController.swift
//  18_Todoey
//
//  Created by Barbara Joseph on 10/09/2019.
//  Copyright © 2019 Gehertt. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray: [String] = ["Find Mike", "Buy Eggs", "Destroy Demogorgon", ]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let itemArr = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = itemArr
        }
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item
        
        return cell
    }
    
    
    // MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
 // MARK - Add New items
    
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert: UIAlertController = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action: UIAlertAction = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            // what will happen once user clicks "Add Item" btn on UIAlert
            self.itemArray.append(textField.text!)
            
            // add array to UD
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    


}

