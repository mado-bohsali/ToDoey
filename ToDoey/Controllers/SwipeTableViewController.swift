//
//  SwipeTableViewController.swift
//  ToDoey
//
//  Created by Mohamad El Bohsaly on 8/17/19.
//

import UIKit
import SwipeCellKit
import Realm

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    var cell:UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //MARK: - Data source methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        //in the identity inspector of the cell (storyboard) change the module and class it inherits from
        
        cell.delegate = self
        
        // Configure the cell...
        cell.textLabel?.font = UIFont(name: "Verdana", size: 13)
        //cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories created yet.."
        
        return cell
    }
    
    // MARK: - SwipeCell kit delegate method
    
    //Asks the delegate for the actions to display in response to a swipe in the specified row.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil } //orientation is from the righr
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]

    }
    
    func updateModel(at indexPath: IndexPath){
        print("Category deleted..")
    }

}
