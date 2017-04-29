import UIKit
import Firebase

class Task: NSObject {
  
  let fireBaseRef = FIRDatabase.database().reference(withPath: "task")
  
  var id: String
  var name: String
  var taskDescription: String
  var numberOfPeopleRequired: Int
  var volunteerIds: [String]
  var dueDate: Date
  var ref: FIRDatabaseReference?
  var key: String?
  
  init(id: String, name: String, taskDescription: String, volunteerIds: [String],
       numberOfPeopleRequired: Int, dueDate: Date) {
    self.id = id
    self.name = name
    self.taskDescription = taskDescription
    self.numberOfPeopleRequired = numberOfPeopleRequired
    self.volunteerIds = volunteerIds
    self.dueDate = dueDate
    self.ref = ref ?? nil
  }
  
  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    let snapshotValue = snapshot.value as! [String: AnyObject]
    
    id = snapshotValue["id"] as! String
    name = snapshotValue["name"] as! String
    taskDescription = snapshotValue["taskDescription"] as! String
    numberOfPeopleRequired = snapshotValue["numberOfPeopleRequired"] as! Int
    volunteerIds = snapshotValue["volunteerIds"] as! [String]
    dueDate = Utils.getTimeStampFromString(timeStampString: snapshotValue["dueDate"] as! String)
    ref = snapshot.ref
  }
  
  
  func toAnyObject() -> Any {
    return [
      "id": id,
      "name": name,
      "taskDescription": taskDescription,
      "numberOfPeopleRequired": numberOfPeopleRequired,
      "volunteerIds": volunteerIds,
      "dueDate": Utils.getTimeStampStringFromDate(date: dueDate)
    ]
  }
  
  func getTestTask() -> Task {
    return Task(id: "1", name: "Task1", taskDescription: "Help with cooking", volunteerIds: ["1","2"], numberOfPeopleRequired: 2, dueDate: Date.init())
  }
  
  
  //Mark:- API
  func storeTask() {
    let taskRef = fireBaseRef.child(id)
    taskRef.setValue(self.toAnyObject())
  }

}
