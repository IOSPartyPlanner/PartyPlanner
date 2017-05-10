import UIKit
import Firebase

class Item: NSObject {

  let fireBaseRef = FIRDatabase.database().reference(withPath: "item")
  
  var id: String
  var name: String
  var itemDescription: String
  var quantityRequired: Int
  var volunteerEmails: [String:String]
  var dueDate: Date
  var ref: FIRDatabaseReference?
  var key: String?
  
  init(id: String, name: String, itemDescription: String, volunteerEmails: [String],
       quantityRequired: Int, dueDate: Date) {
    self.id = id
    self.name = name
    self.itemDescription = itemDescription
    self.quantityRequired = quantityRequired
    for email in volunteerEmails {
      let key = (email.replacingOccurrences(of: ".", with: "")).replacingOccurrences(of: "@", with: "")
      self.volunteerEmails[key] = email
    }
    self.dueDate = dueDate
    self.ref = ref ?? nil
  }
  
  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    let snapshotValue = snapshot.value as! [String: AnyObject]
    
    id = snapshotValue["id"] as! String
    name = snapshotValue["name"] as! String
    itemDescription = snapshotValue["itemDescription"] as! String
    quantityRequired = snapshotValue["quantityRequired"] as! Int
    volunteerEmails = snapshotValue["volunteerEmails"] as! [String:String]
    dueDate = Utils.getTimeStampFromString(timeStampString: snapshotValue["dueDate"] as! String)
    ref = snapshot.ref
  }
  
  
  func toAnyObject() -> Any {
    return [
      "id": id,
      "name": name,
      "itemDescription": itemDescription,
      "quantityRequired": quantityRequired,
      "volunteerEmails": volunteerEmails,
      "dueDate": Utils.getTimeStampStringFromDate(date: dueDate)
    ]
  }
  
}
