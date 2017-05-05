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
  
  static var currentInstance: RSVP? // = RSVP()

  let fireBaseRef = FIRDatabase.database().reference(withPath: "rsvp")
  
  var id: String // eventID + guestUID 
  var eventId: String
  var guestEmail: String
  // the number of persons coming with the guest
  var guestPlusX: Int = 0
  var response: RsvpResponse? = .notResponded
  var ref: FIRDatabaseReference?
  var key: String?
  
  
  
  override init() {
    eventId = ""
    guestEmail = ""
    id = ""
  }
  
  
  init(id: String, eventId: String, guestEmail: String,
       guestPlusX: Int, response: RsvpResponse) {
    self.id = id // RSVP ID
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
  
  func handleRsvpUrl(_ url: URL, completion:@escaping (Bool)->()) {
    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    
    if let queryItems = components?.queryItems {
      for item in queryItems{
        if item.name == "eventId" {
//          RSVP.currentInstance?.eventId = (item.value)!
          EventApi.sharedInstance.getEventById(eventId: item.value!, success: { (event: Event?) in
            print("EventApi.sharedInstance.getEventById", (event?.id)!)
            RSVP.currentInstance?.eventId = (event?.id)! //item.value!
            completion(true)
          }, failure: {
            RSVP.currentInstance?.eventId = ""
            print("Event id is wrong")
            completion(false)
//            return false
          })
//          print("RSVPing to event", item.value!)
        }
      }
    }
  }
  
  
}
