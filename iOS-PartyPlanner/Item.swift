import UIKit
import Firebase

class Item: NSObject {

  let fireBaseRef = FIRDatabase.database().reference(withPath: "item")
  
  var id: String
  var name: String
  var itemDescription: String
  var quantityRequired: Int
  var volunteerIds: [String]
  var dueDate: Date
  var ref: FIRDatabaseReference?
  var key: String?
  
  init(id: String, name: String, itemDescription: String, volunteerIds: [String],
       quantityRequired: Int, dueDate: Date) {
    self.id = id
    self.name = name
    self.itemDescription = itemDescription
    self.quantityRequired = quantityRequired
    self.volunteerIds = volunteerIds
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
    volunteerIds = snapshotValue["volunteerIds"] as! [String]
    dueDate = Utils.getTimeStampFromString(timeStampString: snapshotValue["dueDate"] as! String)
    ref = snapshot.ref
  }
  
  
  func toAnyObject() -> Any {
    return [
      "id": id,
      "name": name,
      "itemDescription": itemDescription,
      "quantityRequired": quantityRequired,
      "volunteerIds": volunteerIds,
      "dueDate": Utils.getTimeStampStringFromDate(date: dueDate)
    ]
  }
  
}
