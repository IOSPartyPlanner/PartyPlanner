import Foundation
import Firebase

@objc protocol TaskApiDelegate {
  @objc optional func taskApi(taskApi: TaskApi, taskUpdated task: Task)
}

class TaskApi: NSObject {
  
  static let sharedInstance = TaskApi()
  private let fireBaseTaskRef = FIRDatabase.database().reference(withPath: "task")
  weak var delegate: TaskApiDelegate?
  
  func storeTask(task: Task) {
    let taskRef = fireBaseTaskRef.child(task.id)
    taskRef.setValue(task.toAnyObject())
    delegate?.taskApi!(taskApi: self, taskUpdated: task)
  }
    
  func addVolunteer(emails: [String], taskId:String) {
    for email in emails{
        let volunteerId = (email.replacingOccurrences(of: ".", with: "")).replacingOccurrences(of: "@", with: "")
        let taskRef = fireBaseTaskRef.child(taskId).child("volunteerEmails").child(volunteerId)
        taskRef.setValue(email)
    }
  }
  
  func removeVolunteer(emails: [String], taskId:String){
    for email in emails{
      let volunteerId = (email.replacingOccurrences(of: ".", with: "")).replacingOccurrences(of: "@", with: "")
      let taskRef = fireBaseTaskRef.child(taskId).child("volunteerEmails").child(volunteerId)
      taskRef.removeValue()
    }
  }
  
  func getTaskById(taskId: String, success: @escaping (Task?) ->(), failure: @escaping () -> ()) {
    print("TaskAPI : searching for taskId \(taskId)")
    var task: Task?
    fireBaseTaskRef.queryOrdered(byChild: "id")
      .queryEqual(toValue: taskId)
      .observe(.value, with: { snapshot in
        for taskChild in snapshot.children {
          task = Task(snapshot: taskChild as! FIRDataSnapshot)
          break
        }
        
        if task == nil {
          failure()
        } else {
          success(task)
        }
      })
  }
  
  func getTasksByEventId(eventId: String, success: @escaping ([Task]) -> (), failure: @escaping () -> ()) {
    print("TaskAPI : searching tasks by eventId:: \(eventId)")
    var tasks = [Task]()
    fireBaseTaskRef.queryOrdered(byChild: "eventId")
      .queryEqual(toValue: eventId)
      .observe(.value, with: { snapshot in
        for taskChild in snapshot.children {
          let task = Task(snapshot: taskChild as! FIRDataSnapshot)
          tasks.append(task)
        }
        
        if tasks == nil {
          failure()
        } else {
          success(tasks)
        }
      })
  }
}
