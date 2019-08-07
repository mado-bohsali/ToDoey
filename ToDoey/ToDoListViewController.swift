//
//  ViewController.swift
//  ToDoey
//
//  Created by Mohamad El Bohsaly on 8/7/19.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var items = ["Pack the luggages","Coordinate with a dirver","Visit Turkey"]
    //programmatic interface for interacting with the defaults system - .plist file
    let user_defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let list = user_defaults.array(forKey: "ToDoeyListArray") as? [String] {
            items = list
        }
    }
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
            cell.textLabel?.text = items[indexPath.row]
            cell.textLabel?.font = UIFont(name: "Verdana", size: 13)
            return cell
        }

    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.row])
        
        //Grab a reference for the cell at indexPath
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else{
            //uncheck
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            
            self.items.append(textField.text!) //cannot add NIL
            self.user_defaults.set(self.items, forKey: "ToDoeyListArray") //
            
            //update TableView
            self.tableView.reloadData()
        }
        
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
}



