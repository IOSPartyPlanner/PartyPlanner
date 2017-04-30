import UIKit
import Firebase

class Comment: NSObject {

  let fireBaseRef = FIRDatabase.database().reference(withPath: "comment")
 
  var id: String
  var userEmail: String
  var eventId: String
  var date: Date
  var text: String
  var ref: FIRDatabaseReference?
  var key: String?
  
  init(id: String, userEmail: String, eventId: String, date: Date, text: String) {
    self.id = id
    self.userEmail = userEmail
    self.eventId = eventId
    self.date = date
    self.text = text
  }
  
  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    ref = snapshot.ref
    
    let snapshotValue = snapshot.value as! [String: AnyObject]
    id = snapshotValue["id"] as! String
    userEmail = snapshotValue["userEmail"] as! String
    eventId = snapshotValue["eventId"] as! String
    date = Utils.getTimeStampFromString(timeStampString: snapshotValue["date"] as! String)
    text = snapshotValue["text"] as! String
  }
  
  func toAnyObject() -> Any {
    return [
      "id": id,
      "userEmail": userEmail,
      "eventId": eventId,
      "date": Utils.getTimeStampStringFromDate(date: date),
      "text": text
    ]
  }
  
  
}
