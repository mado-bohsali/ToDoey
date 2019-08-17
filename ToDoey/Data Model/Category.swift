//
//  Category.swift
//  ToDoey
//
//  Created by Mohamad El Bohsaly on 8/12/19.
//

import Foundation
import RealmSwift


class Category:Object{
    @objc dynamic var name:String = ""
    @objc dynamic var color:String = ""
    //forward relationship: 1-to-many
    let items = List<Item>() //container built-in Realm
    
    
}
