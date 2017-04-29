//
//  Comment.swift
//  iOS-PartyPlanner
//
//  Created by Bharath D N on 4/26/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import Firebase

class Comment: NSObject {
 
  var id: String
  var user: User
  var event: Event
  var date: Date
  var text: String
  var ref: FIRDatabaseReference?
  var key: String?
  
  init(id: String, user: User, event: Event, date: Date, text: String) {
    self.id = id
    self.user = user
    self.event = event
    self.date = date
    self.text = text
  }
  
  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    ref = snapshot.ref
    
    let snapshotValue = snapshot.value as! [String: AnyObject]
    id = snapshotValue["id"] as! String
    user = snapshotValue["user"] as! User
    event = snapshotValue["event"] as! Event
    date = snapshotValue["date"] as! Date
    text = snapshotValue["text"] as! String
  }
  
  func toAnyObject() -> Any {
    return [
      "id": id,
      "user": user,
      "event": date,
      "date": date,
      "text": text
    ]
  }
  
  
}
