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
  
  func getItemById(itemId: String, success: @escaping (Item?) ->(), failure: ((APIFetchError) -> ())?)  {
    print("TaskAPI : searching item by ID \(itemId)")
    fireBaseItemRef.queryOrdered(byChild: "id").queryEqual(toValue: itemId)
      .observe(.value, with: { snapshot in
        if let firstChild = snapshot.children.nextObject() {
            let item = Item(snapshot: firstChild as! FIRDataSnapshot)
            success(item)
        } else {
            if let failure = failure {
                failure(.NoItemFoundError)
            }
        }
      })
  }
  
  func getItemsByEventId(eventId: String, success: @escaping ([Item]) -> (), failure: ((APIFetchError) -> ())?) {
    print("TaskAPI : searching Items by eventId:: \(eventId)")
    fireBaseItemRef.queryOrdered(byChild: "eventId").queryEqual(toValue: eventId)
      .observe(.value, with: { snapshot in
        if snapshot.childrenCount > 0 {
            let items = snapshot.children.map{  return Item(snapshot: $0 as! FIRDataSnapshot) }
            success(items)
        } else {
            if let failure = failure {
                failure(.NoItemFoundError)
            }
        }
      })
  }
}
