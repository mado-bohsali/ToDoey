//
//  ViewController.swift
//  ToDoey
//
//  Created by Mohamad El Bohsaly on 8/7/19.
//  Controller

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    var items:Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var search_bar: UISearchBar!
    
    var selected_category:Category?{ //optional
        didSet{
            loadItems() //items are pre-initiazlied / saved
        }
    }
    
    //programmatic interface for interacting with the defaults system - .plist file
    //let user_defaults = UserDefaults.standard
    let data_file_path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //Singleton shared
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.rowHeight = 75.0
        
        print(data_file_path!)
    }
    
    override func viewWillAppear(_ animated: Bool) { //just before viewDidLoad
        if let nav_color = selected_category?.color{
            title = selected_category!.name
            
            guard let nav_bar = navigationController?.navigationBar else{
                fatalError("Navigation controller does NOT exist.")
            }
            nav_bar.barTintColor = UIColor(hexString: nav_color)
            nav_bar.tintColor = ContrastColorOf(UIColor(hexString: nav_color)!, returnFlat: true)
            search_bar.barTintColor = UIColor(hexString: nav_color)
        }
    }
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //upon app loading - cen be manually triggered later
        //Difference: the checking/unchecking is lost once a cell is not shown on the screen vs being dequeued and reused
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row]{
            cell.textLabel?.font = UIFont(name: "Verdana", size: 13)
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let color = UIColor(hexString: selected_category!.color)?.darken(byPercentage:CGFloat(indexPath.row)/CGFloat(items!.count)){
                cell.backgroundColor = color
                //flat color: SOLID - means solid ink coverage with no gradations, screens or halftones
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: false)
            }
            
            
        } else{
            cell.textLabel?.font = UIFont(name: "Verdana", size: 13)
            cell.textLabel?.text = "No items added so far.."
        }
        
        return cell
    }

    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row]{
            do {
                try realm.write{
                  item.done = !item.done
                  //OR items[indexPath.row].setValue(!items[indexPath.row].done, forKey: "done")
                    
                  //realm.delete(item)
//                    save(item: item)
                }
            } catch{
               print("Error saving done status \(error)")
            }
            
        }
        
        tableView.reloadData()
//        save(item)
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
           // _ = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            if let current_category = self.selected_category{
                do {
                    try self.realm.write {
                        let item = Item()//(context: self.context)
                        item.title = textField.text!
                        item.date_created = Date()
                        current_category.items.append(item)
                        //self.save(item: item)
                        self.realm.add(item)
                    }
                    
                } catch{
                    
                }
            }
            
            self.tableView.reloadData()
            
            //self.items.append(item) //cannot add NIL
            //self.user_defaults.set(self.items, forKey: "ToDoeyListArray")
//            self.saveItem()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Manipulation of boolean
//    func saveItem(){
//        do{
//            try context.save()
//        } catch{
//            print("Error while encoding: \(error)")
//        }
//
//        //update TableView
//        self.tableView.reloadData()
//
//    }

    func save(item:Item){
        do{
            try realm.write{
                realm.add(item)
            }
        } catch{
            print("Error saving item: \(error)")
        }

        //update TableView
        self.tableView.reloadData()
    }
//    func loadItems(){ //V 1.0
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
    
    
      //V 1.5
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate?=nil){
//        let category_predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selected_category!.name!)
//
//        //AND-ing predicates
//        if predicate != nil{
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [category_predicate, predicate!])
//        } else{
//            request.predicate = category_predicate
//        }
//
//        do{
//            //items = try context.fetch(request)
//        } catch{
//            print("Error in fetching data")
//        }
//
//        tableView.reloadData()
//    }

    func loadItems(){ //V 2.0
        items = selected_category?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = items?[indexPath.row]{
            do{
                try! realm.write {
                    realm.delete(item)
                }
            } catch{
                print("Error deleting item \(error)")
            }
        }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Search bar methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request:NSFetchRequest<Item> = Item.fetchRequest()
//
//        //definition of logical conditions used to constrain a search
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        //array
//
//        loadItems(with: request, predicate: predicate) //with is an external parameter
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date_created", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            //loadItems() //fetch the original list if nothing is typed
            
            //no longer selected, keyboard is hidden, no cursor
            //Use a DispatchQueue
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }

}



