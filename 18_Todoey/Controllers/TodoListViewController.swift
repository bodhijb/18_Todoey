//
//  ViewController.swift
//  18_Todoey
//
//  Created by Barbara Joseph on 10/09/2019.
//  Copyright © 2019 Gehertt. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray: [Item] = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(dataFilePath!)

        loadItems()
        
    }
    
    
    
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
        // print(itemArray[indexPath.row])
        
        // set done value
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
 // MARK - Add New items
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert: UIAlertController = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action: UIAlertAction = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            // what will happen once user clicks "Add Item" btn on UIAlert
            let newItem = Item()
            newItem.title = textField.text!
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
        // create an encoder to break down the array into a storable form
        let encoder = PropertyListEncoder()
        
        do {
            // the encoded array
            let data = try encoder.encode(itemArray)
            //write the data to the dataFP
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding the item array \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems() {
    // if you get anything back from the file path, use a decoder to assign contents to itemArr
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do{
                itemArray = try decoder.decode([Item].self, from: data)
                
            } catch {
            print("Error retreiving data \(error)")
            }
        }
        
    }
    
    
    


}

