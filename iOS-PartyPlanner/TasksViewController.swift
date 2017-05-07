//
//  TasksViewController.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        fetchTasks()
        addTaskView.isHidden = true
        blurView.isHidden = true
        
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
            cell.taskStatusImage.image = UIImage(named: "unchecked")
        }
        else{
           cell.task = assignedTaskList[indexPath.item]
           cell.taskStatusImage.image = UIImage(named: "checked")
        }
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchTasks(){
            //TODO: It returns data 2 times - Bug
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
      
      /*  let createdTask = Task(id: "8982", name: taskNameTextField.text!, eventId: "1", taskDescription: taskDescriptionTextField.text, numberOfPeopleRequired: (Int)(requiredPeopleCountTextField.text!)!, dueDate: Utils.getTimeStampFromString(timeStampString: "Fri May 18 16:36:57 -0700 2017"))*/
        
        let taskId = taskNameTextField.text! + taskDescriptionTextField.text + requiredPeopleCountTextField.text!
        let createdTask = Task(id: taskId, name: taskNameTextField.text!, eventId: (event?.id)!, taskDescription: taskDescriptionTextField.text, numberOfPeopleRequired: (Int)(requiredPeopleCountTextField.text!)!, dueDate: Utils.getTimeStampFromString(timeStampString: String(describing: event?.dateTime)))
        TaskApi.sharedInstance.storeTask(task: createdTask)
        addTaskView.isHidden = true
        blurView.isHidden = true
    }
    
}
