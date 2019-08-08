//
//  ViewController.swift
//  ToDoey
//
//  Created by Mohamad El Bohsaly on 8/7/19.
//  Controller

import UIKit

class ToDoListViewController: UITableViewController {

    var items = [Item]()
    
    //programmatic interface for interacting with the defaults system - .plist file
    let user_defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let first_item =  Item()
        first_item.title = "Head to the airport"
        
        let second_item = Item()
        second_item.title = "Check in"
        
        let third_item = Item()
        third_item.title = "Shop at duty free"
        
        items.append(first_item)
        items.append(second_item)
        items.append(third_item)
        
        
        if let list = user_defaults.array(forKey: "ToDoeyListArray") as? [Item] {
            items = list //update the list to refer to user_defaults
        }
    }
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //upon app loading - cen be manually triggered later
        //Difference: the checking/unchecking is lost once a cell is not shown on the screen vs being dequeued and reused
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        cell.textLabel?.text = items[indexPath.row].title
        cell.textLabel?.font = UIFont(name: "Verdana", size: 13)
        
        //Ternary operator
        cell.accessoryType = items[indexPath.row].done ? .checkmark: .none
        
        return cell
    }

    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.row])
        
        items[indexPath.row].done = !items[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Item
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new item", message: "", preferredStyle: .alert)
        
        //Text field within alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new item"
            textField = alertTextField //cross-reference
        }
        
        let action = UIAlertAction(title: "Add", style: .default){ (action) in
            //once the user clicks Add button on the alert
            print("Success! A new item added!")
            
            let item = Item()
            item.title = textField.text!
            
            self.items.append(item) //cannot add NIL
            self.user_defaults.set(self.items, forKey: "ToDoeyListArray") //
            
            //update TableView
            self.tableView.reloadData()
        }
        
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
}



