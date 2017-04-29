import UIKit
import Firebase

enum RsvpResponse: String {
  case yes
  case maybe
  case no
  case notResponded
}

import UIKit

class RSVP: NSObject {
  
  let fireBaseRef = FIRDatabase.database().reference(withPath: "rsvp")
  
  var id: String
  var eventId: String
  var guestId: String
  // the number of persons coming with the guest
  var guestIdPlusX: Int = 0
  var response: RsvpResponse? = .notResponded
  var ref: FIRDatabaseReference?
  var key: String?
  
  init(id: String, eventId: String, guestId: String,
       guestIdPlusX: Int, response: RsvpResponse) {
    self.id = id
    self.eventId = eventId
    self.guestId = guestId
    self.guestIdPlusX = guestIdPlusX
    self.response = response
  }
  
  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    ref = snapshot.ref
    let snapshotValue = snapshot.value as! [String: AnyObject]
    
    id = snapshotValue["id"] as! String
    eventId = snapshotValue["eventId"] as! String
    guestId = snapshotValue["guestId"] as! String
    guestIdPlusX = snapshotValue["guestIdPlusX"] as! Int
    response = RsvpResponse(rawValue: (snapshotValue["response"] as? String)!)
  }
  
  
  func toAnyObject() -> Any {
    return [
      "id": id,
      "eventId": eventId,
      "guestId": guestId,
      "guestIdPlusX": guestIdPlusX,
      "response": response!.rawValue
    ]
  }
}
