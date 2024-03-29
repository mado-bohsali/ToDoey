//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Mohamad El Bohsaly on 8/9/19.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    
    let realm = try! Realm()
    
    //var categories = [Category]()
    var categories:Results<Category>?
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //V1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadCategories()
        tableView.rowHeight = 75.0
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1 //NIL coalesce operator
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //in the identity inspector of the cell (storyboard) change the module and class it inherits from
        
        //cell.delegate = self

        // Configure the cell...
        cell.textLabel?.font = UIFont(name: "Verdana", size: 13)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories created yet.."
        
        if let cell_background = UIColor(hexString:categories?[indexPath.row].color ?? "1D9BF6"){
            cell.backgroundColor = cell_background
            cell.textLabel?.textColor = ContrastColorOf(cell_background, returnFlat: false)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "itemSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination_view_controller = segue.destination as! ToDoListViewController
        
        if let index_path = tableView.indexPathForSelectedRow{
            destination_view_controller.selected_category = categories?[index_path.row]
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var text_field = UITextField()
        
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (field) in
            text_field = field
            text_field.placeholder = "Add a new category"
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let category = Category()//(context: self.context)
            category.name = text_field.text!
            category.color = UIColor.randomFlat.hexValue()
            self.save(category:category)
        }
        
        alert.addAction(action)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        })
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Manipulation methods
    func save(category:Category){
        do{
            //try context.save()
            try realm.write {
                realm.add(category)
            }
        } catch{
            print("Error saving your changes: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(){
//        let request:NSFetchRequest<Category> = Category.fetchRequest()
//        do{
//            categories = try context.fetch(request)
//        } catch{
//            print("Error loading your categories: \(error)")
//        }

        categories = realm.objects(Category.self) //container, Result<Category>
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        do{
            try! realm.write {
                realm.delete(self.categories![indexPath.row])
            }
        }catch{
            print("Error deleting category \(error)")
        }
        
        tableView.reloadData()
    }
}
