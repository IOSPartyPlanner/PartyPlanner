import UIKit
import Firebase

class Task: NSObject {
  
  let fireBaseRef = FIRDatabase.database().reference(withPath: "task")
  
  var id: String
  var name: String
  var eventId: String
  var eventName: String?
  var taskDescription: String
  var numberOfPeopleRequired: Int
  var volunteerEmails: [String]?
  var dueDate: Date
  var ref: FIRDatabaseReference?
  var key: String?
  
  init(id: String, name: String,
       eventId: String,taskDescription: String, volunteerEmails:[String],numberOfPeopleRequired: Int, dueDate: Date) {
    self.id = id
    self.name = name
    self.eventId = eventId
    self.taskDescription = taskDescription
    self.numberOfPeopleRequired = numberOfPeopleRequired
    self.volunteerEmails = volunteerEmails
    self.dueDate = dueDate
    self.ref = ref ?? nil
  }
  
  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    let snapshotValue = snapshot.value as! [String: AnyObject]
    
    id = snapshotValue["id"] as! String
    name = snapshotValue["name"] as! String
    eventId = snapshotValue["eventId"] as! String
    taskDescription = snapshotValue["taskDescription"] as! String
    numberOfPeopleRequired = snapshotValue["numberOfPeopleRequired"] as! Int
    volunteerEmails = snapshotValue["volunteerEmails"] as? [String]
    dueDate = Utils.getTimeStampFromString(timeStampString: snapshotValue["dueDate"] as! String)
    ref = snapshot.ref
  }
  
  
  func toAnyObject() -> Any {
    return [
      "id": id,
      "name": name,
      "eventId": eventId,
      "taskDescription": taskDescription,
      "numberOfPeopleRequired": numberOfPeopleRequired,
      "volunteerEmails": volunteerEmails,
      "dueDate": Utils.getTimeStampStringFromDate(date: dueDate)
    ]
  }
  
}
