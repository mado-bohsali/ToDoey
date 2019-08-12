//
//  ViewController.swift
//  ToDoey
//
//  Created by Mohamad El Bohsaly on 8/7/19.
//  Controller

import UIKit
import CoreData

class ToDoListViewController: UITableViewController, UISearchBarDelegate {

    var items = [Item]()
    var selected_category:Category?{
        didSet{
            loadItems() //items are pre-initiazlied / saved
        }
    }
    //programmatic interface for interacting with the defaults system - .plist file
    //let user_defaults = UserDefaults.standard
    let data_file_path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //Singleton shared
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Encode with NSCoder
        
        print(data_file_path!)
        
        
    }
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //upon app loading - cen be manually triggered later
        //Difference: the checking/unchecking is lost once a cell is not shown on the screen vs being dequeued and reused
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
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
        //OR items[indexPath.row].setValue(!items[indexPath.row].done, forKey: "done")
        
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
            
            //Access the singleton (shared) UIApplication object
            _ = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let item = Item(context: self.context)
            item.title = textField.text!
            item.done = false
            item.parentCategory = self.selected_category
            self.items.append(item) //cannot add NIL
            //self.user_defaults.set(self.items, forKey: "ToDoeyListArray")
            self.saveItem()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Manipulation of boolean
    func saveItem(){
        do{
            try context.save()
        } catch{
            print("Error while encoding: \(error)")
        }
        
        //update TableView
        self.tableView.reloadData()

    }
    
//    func loadItems(){
//        if let data = try? Data(contentsOf: data_file_path!){
//            let decoder = PropertyListDecoder()
//            do{
//                items = try decoder.decode([Item].self, from: data)
//            } catch{
//                print("Error while decoding: \(error)")
//            }
//        }
//
//
//    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate?=nil){
        let category_predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selected_category!.name!)
        
        //AND-ing predicates
        if let compound_predicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [category_predicate, compound_predicate])
        } else{
            request.predicate = category_predicate
        }
        
        do{
            items = try context.fetch(request)
        } catch{
            print("Error in fetching data")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Search bar methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        
        //definition of logical conditions used to constrain a search
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //array
        
        loadItems(with: request, predicate: predicate) //with is an external parameter
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems() //fetch the original list
            
            //no longer selected, keyboard is hidden, no cursor
            //Use a DispatchQueue
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }

}



