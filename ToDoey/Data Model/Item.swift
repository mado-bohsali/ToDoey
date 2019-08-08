//
//  Item.swift
//  ToDoey
//
//  Created by Mohamad El Bohsaly on 8/8/19.
//  Data Model

import Foundation

class Item:Encodable,Decodable{
    var title:String = ""
    var done:Bool = false
}
