import UIKit
import Firebase

class Task: NSObject {
  
  var id: String
  var name: String
  var taskDescription: String
  var numberOfPeople: Int
  var dueDate: Date
  var ref: FIRDatabaseReference?
  var key: String?
  
  init(id: String, name: String, taskDescription: String,
       numberOfPeople: Int, dueDate: Date) {
    self.id = id
    self.name = name
    self.taskDescription = taskDescription
    self.numberOfPeople = numberOfPeople
    self.dueDate = dueDate
    self.ref = ref ?? nil
  }
  
  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    let snapshotValue = snapshot.value as! [String: AnyObject]
    
    id = snapshotValue["id"] as! String
    name = snapshotValue["name"] as! String
    taskDescription = snapshotValue["taskDescription"] as! String
    numberOfPeople = snapshotValue["numberOfPeople"] as! Int
    dueDate = snapshotValue["dueDate"] as! Date
    ref = snapshot.ref
  }
  
  
  func toAnyObject() -> Any {
    return [
      "id": id,
      "name": name,
      "taskDescription": taskDescription,
      "numberOfPeople": numberOfPeople,
      "dueDate": dueDate
    ]
  }

}
