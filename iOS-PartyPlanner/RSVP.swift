import UIKit
import Firebase

enum RsvpResponse {
  case yes
  case maybe
  case no
  case notResponded
}

import UIKit

class RSVP: NSObject {
  
  var id: String
  var event: Event
  var guest: User
  // the number of persons coming with the guest
  var guestPlusX: Int = 0
  var response: RsvpResponse? = .notResponded
  var ref: FIRDatabaseReference?
  var key: String?
  
  init(id: String, event: Event, guest: User,
       guestPlusX: Int, response: RsvpResponse) {
    self.id = id
    self.event = event
    self.guest = guest
    self.guestPlusX = guestPlusX
    self.response = response
  }
  
  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    ref = snapshot.ref
    let snapshotValue = snapshot.value as! [String: AnyObject]
    
    id = snapshotValue["id"] as! String
    event = snapshotValue["event"] as! Event
    guest = snapshotValue["guest"] as! User
    guestPlusX = snapshotValue["guestPlusX"] as! Int
    response = snapshotValue["response"] as? RsvpResponse
  }
  
  
  func toAnyObject() -> Any {
    return [
      "id": id,
      "event": event,
      "guest": guest,
      "guestPlusX": guestPlusX,
      "response": response!
    ]
  }
}
