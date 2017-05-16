//
//  TasksViewController.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

@objc protocol TasksViewControllerDelegate {
  @objc optional func tasksViewController(tasksViewController: TasksViewController, tasksAddedCount count: Int)
}

class TasksViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
  
  @IBOutlet var tasksTableView: UITableView!
  var assignedTaskList = [Task]()
  var unassignedTaskList = [Task]()
  
  @IBOutlet var addTaskView: UIView!
  @IBOutlet var taskNameTextField: UITextField!
  @IBOutlet var taskDescriptionTextField: UITextView!
  @IBOutlet var requiredPeopleCountTextField: UITextField!
  @IBOutlet var cancelButton: UIButton!
  @IBOutlet var addButton: UIButton!
  @IBOutlet var blurView: UIVisualEffectView!
  
  var event : Event?
  var isNewevent: Bool?
  weak var delegate: TasksViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //if !isNewevent! {
      fetchTasks()
   // }
    addTaskView.isHidden = true
    blurView.isHidden = true
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    let count = assignedTaskList.count + unassignedTaskList.count
    delegate?.tasksViewController!(tasksViewController: self, tasksAddedCount: count)
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "Unassigned Tasks"
    }
    else{
      return "Assigned Tasks"
    }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                return unassignedTaskList.count
            }
            else {
                return assignedTaskList.count
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        if indexPath.section == 0 {
           cell.task = unassignedTaskList[indexPath.item]
           cell.taskStatusImage.isHidden = true
            if unassignedTaskList[indexPath.item].volunteerEmails != nil && (unassignedTaskList[indexPath.item].volunteerEmails?.values.contains((User._currentUser?.email)!))!{
                cell.colorView.layer.backgroundColor = UIColor.green.cgColor
            }
            else{
                 cell.colorView.layer.backgroundColor = UIColor.yellow.cgColor
            }
        }
        else{
           cell.taskStatusImage.isHidden = true
           cell.task = assignedTaskList[indexPath.item]
           cell.colorView.layer.backgroundColor = UIColor.red.cgColor
         
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //It returns data 2 times - Bug
        let section = indexPath.section
        var volunteers = [String]()
        volunteers.append((User._currentUser?.email)!)
    
        if section == 0 {
            let task = unassignedTaskList[indexPath.item]
            if task.volunteerEmails == nil {
                TaskApi.sharedInstance.addVolunteer(emails: volunteers, taskId: task.id)
                tasksTableView.reloadRows(at: [indexPath], with: .bottom)
            }
            else if !(task.volunteerEmails?.values.contains((User._currentUser?.email)!))! {
                TaskApi.sharedInstance.addVolunteer(emails: volunteers, taskId: task.id)
                tasksTableView.reloadRows(at: [indexPath], with: .bottom)
            }
                
            else {
                TaskApi.sharedInstance.removeVolunteer(emails: volunteers, taskId: task.id)
                tasksTableView.reloadRows(at: [indexPath], with: .top)
            }
             
        }
        else{
            let task = assignedTaskList[indexPath.item]
            
            if task.volunteerEmails != nil && !(task.volunteerEmails?.values.contains((User._currentUser?.email)!))!
                && (task.numberOfPeopleRequired - (task.volunteerEmails?.count)!) > 0 {
                
                TaskApi.sharedInstance.addVolunteer(emails: volunteers, taskId: task.id)
                tasksTableView.reloadRows(at: [indexPath], with: .bottom)
            }
                
            else if task.volunteerEmails != nil && (task.volunteerEmails?.values.contains((User._currentUser?.email)!))! {
                TaskApi.sharedInstance.removeVolunteer(emails: volunteers, taskId: task.id)
                tasksTableView.reloadRows(at: [indexPath], with: .top)
            }
            
        }
        
        tasksTableView.deselectRow(at:indexPath, animated: true)

    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func fetchTasks(){
    //TODO: It returns data 2 times - Bug
    // (event?.id)!
    TaskApi.sharedInstance.getTasksByEventId(eventId: (event?.id)!, success: {(tasks: [Task])
      in
      self.assignedTaskList = [Task]()
      self.unassignedTaskList = [Task]()
      for task in tasks {
        
        if task.volunteerEmails?.count != nil {
          if (task.numberOfPeopleRequired - (task.volunteerEmails?.count)!) > 0{
            self.unassignedTaskList.append(task)
          }
          else{
            self.assignedTaskList.append(task)
          }
        }
        else {
          if task.numberOfPeopleRequired > 0 {
            self.unassignedTaskList.append(task)
          }
          else{
            self.assignedTaskList.append(task)
          }
          
        }
        
      }
      
      self.tasksTableView.reloadData()
      
      
    }, failure:{})
    
  }
  
  @IBAction func itemBarOnClickAdd(_ sender: Any) {
    taskNameTextField.text = ""
    taskDescriptionTextField.text = ""
    requiredPeopleCountTextField.text = ""
    addTaskView.isHidden = false
    blurView.isHidden = false
  }
  
  @IBAction func onClickCancel(_ sender: Any) {
    addTaskView.isHidden = true
    blurView.isHidden = true
  }
  
  @IBAction func onClickAdd(_ sender: Any) {
    let volunteerEmails = [String]()
    let taskId = Utils.generateUUID()
      // taskNameTextField.text! + taskDescriptionTextField.text + requiredPeopleCountTextField.text!
    /*let createdTask = Task(id: taskId, name: taskNameTextField.text!, eventId: "1", taskDescription: taskDescriptionTextField.text,volunteerEmails: volunteerEmails, numberOfPeopleRequired: (Int)(requiredPeopleCountTextField.text!)!, dueDate: Utils.getTimeStampFromString(timeStampString: "Fri May 18 16:36:57 -0700 2017"))
     TaskApi.sharedInstance.storeTask(task: createdTask)*/
    print( taskNameTextField.text!)
    print(event?.id as Any)
    print(requiredPeopleCountTextField.text!)
    
    let createdTask = Task(id: taskId, name: taskNameTextField.text!, eventId: (event?.id)!, taskDescription: taskDescriptionTextField.text,volunteerEmails: volunteerEmails, numberOfPeopleRequired: (Int)(requiredPeopleCountTextField.text!)!, dueDate: (event?.dateTime)!)
    TaskApi.sharedInstance.storeTask(task: createdTask)
    addTaskView.isHidden = true
    blurView.isHidden = true
  }
  
}
