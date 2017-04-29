//
//  Item.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import Firebase

class Item: NSObject {

  var id: String
  var name: String
  var quantity: Int
  var dueDate: Date
  var ref: FIRDatabaseReference?
  var key: String?
  
  init(id: String, name: String, quantity: Int, dueDate: Date) {
    self.id = id
    self.name = name
    self.quantity = quantity
    self.dueDate = dueDate
  }
  
  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    ref = snapshot.ref
    let snapshotValue = snapshot.value as! [String: AnyObject]
    
    id = snapshotValue["id"] as! String
    name = snapshotValue["name"] as! String
    quantity = snapshotValue["quantity"] as! Int
    dueDate = snapshotValue["dueDate"] as! Date
  }
  
  func toAnyObject() -> Any {
    return [
      "id": id,
      "name": name,
      "quantity": quantity,
      "dueDate": dueDate
    ]
  }
  
}
