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
  var guestEmail: String
  // the number of persons coming with the guest
  var guestPlusX: Int = 0
  var response: RsvpResponse? = .notResponded
  var ref: FIRDatabaseReference?
  var key: String?
  
  init(id: String, eventId: String, guestEmail: String,
       guestPlusX: Int, response: RsvpResponse) {
    self.id = id
    self.eventId = eventId
    self.guestEmail = guestEmail
    self.guestPlusX = guestPlusX
    self.response = response
  }
  
  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    ref = snapshot.ref
    let snapshotValue = snapshot.value as! [String: AnyObject]
    
    id = snapshotValue["id"] as! String
    eventId = snapshotValue["eventId"] as! String
    guestEmail = snapshotValue["guestEmail"] as! String
    guestPlusX = snapshotValue["guestPlusX"] as! Int
    response = RsvpResponse(rawValue: (snapshotValue["response"] as? String)!)
  }
  
  
  func toAnyObject() -> Any {
    return [
      "id": id,
      "eventId": eventId,
      "guestEmail": guestEmail,
      "guestPlusX": guestPlusX,
      "response": response!.rawValue
    ]
  }
}
