//
//  CategoryTableViewController.swift
//  18_Todoey
//
//  Created by Barbara Joseph on 19/09/2019.
//  Copyright © 2019 Gehertt. All rights reserved.
//

import UIKit
import CoreData


class CategoryTableViewController: UITableViewController {
    
    var categories: [Category] = [Category]()
    
    // set up a context space
    // refresh explanation
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()
        
        

    }
    
    
    // MARK: - Table view Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    

    
    // MARK: - Data Manipulation Methods
    
    func saveCategories() {
    //        commit our context to permanent storage inside persistentContainer. xfer data from context
    //        (staging area) to perm. storage (pers..Container)
    // save context in do-catch block
        do {
            try context.save()
        }
        catch {
            print("Error saving category: \(error)")
        }
    // reload table.. static method
        tableView.reloadData()
    
    }
    
    
    func loadCategories(requestSubmitted requestReceived: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            try categories = context.fetch(requestReceived)
        }
        catch {
            print("Error fetching data from context: \(error)")
        }
        // reload data
        tableView.reloadData()
    }


    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // textfield that will hold the cat name
        var textfield = UITextField()
        // create the alert and action details
        let alert: UIAlertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "Add", style: .default) {
            (action) in
            // create a new category item, creating it in the context area
            let newCategory = Category(context: self.context)
            
            // give it a name
            newCategory.name = textfield.text!
            // append to category array
            self.categories.append(newCategory)
            // saveCategories()
            self.saveCategories()
            
        }
        // add textfield to the alert
        alert.addTextField { (field) in
            textfield = field
            field.placeholder = "Add a New Category"
        }
        
        // add action to alert
        alert.addAction(action)
        // finally, present the alert in an animated way
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Tableview Delegate Methods
    
    // when they select the row, leads to all items under that category
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //create a destinationVC here
        let destinationVC = segue.destination as! TodoListViewController
        
        //assign the destVC.selectedCat == catArray[indexPath.row]
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
        

        
        
    }
    
    
    

    
    
    
    
    
    
}








