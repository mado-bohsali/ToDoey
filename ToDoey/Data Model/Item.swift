//
//  Item.swift
//  ToDoey
//
//  Created by Mohamad El Bohsaly on 8/12/19.
//

import Foundation
import RealmSwift

class Item:Object{
    //dynamic keyword for value change tracking at runtime
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var date_created:Date?
    
    var parent_category = LinkingObjects(fromType: Category.self, property: "items") //forward relationship
}
