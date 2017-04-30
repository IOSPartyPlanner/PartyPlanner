//
//  ItemApi.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 4/29/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import Foundation
import Firebase

@objc protocol ItemApiDelegate {
  @objc optional func itemApi(itemApi: ItemApi, taskUpdated task: Item)
}

class ItemApi: NSObject {
  
  static let sharedInstance = ItemApi()
  private let fireBaseItemRef = FIRDatabase.database().reference(withPath: "item")
  weak var delegate: ItemApiDelegate?
  
  func storeItem(item: Item) {
    let itemRef = fireBaseItemRef.child(item.id)
    itemRef.setValue(item.toAnyObject())
    delegate?.itemApi!(itemApi: self, taskUpdated: item)
  }
  
  func getItemById(itemId: String, success: @escaping (Item?) ->(), failure: @escaping () -> ()) {
    print("TaskAPI : searching item by ID \(itemId)")
    var item: Item?
    fireBaseItemRef.queryOrdered(byChild: "id")
      .queryEqual(toValue: itemId)
      .observe(.value, with: { snapshot in
        for itemChild in snapshot.children {
          item = Item(snapshot: itemChild as! FIRDataSnapshot)
          break
        }
        
        if item == nil {
          failure()
        } else {
          success(item)
        }
      })
  }
  
  func getItemsByEventId(eventId: String, success: @escaping ([Item]) -> (), failure: @escaping () -> ()) {
    print("TaskAPI : searching Items by eventId:: \(eventId)")
    var items: [Item]?
    fireBaseItemRef.queryOrdered(byChild: "eventId")
      .queryEqual(toValue: eventId)
      .observe(.value, with: { snapshot in
        for itemChild in snapshot.children {
          let item = Item(snapshot: itemChild as! FIRDataSnapshot)
          items?.append(item)
        }
        
        if items == nil {
          failure()
        } else {
          success(items!)
        }
      })
  }
}
