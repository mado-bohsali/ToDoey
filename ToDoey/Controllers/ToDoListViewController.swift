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
    //let user_defaults = UserDefaults.standard
    let data_file_path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Encode with NSCoder
        
        print(data_file_path!)
        
        loadItems() //items are pre-initiazlied / saved
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
        saveItem()
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
            //self.user_defaults.set(self.items, forKey: "ToDoeyListArray")
            self.saveItem()
        }
        
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Manipulation of boolean
    func saveItem(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(items)
            try data.write(to:data_file_path!)
        } catch{
            print("Error while decoding \(error)")
        }
        
        //update TableView
        self.tableView.reloadData()

    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: data_file_path!){
            let decoder = PropertyListDecoder()
            do{
                items = try decoder.decode([Item].self, from: data)
            } catch{
                print("Error while decoding \(error)")
            }
        }
        
        
    }
}



