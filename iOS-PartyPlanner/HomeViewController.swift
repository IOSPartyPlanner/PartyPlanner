//
//  HomeViewController.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit
import MBProgressHUD


class HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{

  @IBAction func onSignout(_ sender: Any) {
    User.currentUser?.signout()
  }
    
    @IBOutlet var homeSegmentedControl: UISegmentedControl!
    @IBOutlet var homeTableView: UITableView!
    var refreshControl:UIRefreshControl!
    var pastEventList = [Event]()
    var upcomingEventList = [Event]()
    var taskList = [Task]() //Task list of the user for each event
    var tasksList = [[Task]]() // Whole events tasks
    var sectionEvents = ["Upcoming", "Past"]
    var sectionTasks = [String]()
    var sign = 0 // 0.Display Events 1.Display Tasks
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        homeTableView.insertSubview(refreshControl, at: 0)
        fetchEvents()
        
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        //TODO:Needed to check refreshing part
        /*pastEventList = [Event]()
        upcomingEventList = [Event]()
        tasksList = [[Task]]()
        sectionTasks = [String]()
        fetchEvents()*/
        refreshControl.endRefreshing()
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch homeSegmentedControl.selectedSegmentIndex
        {
        case 0:
            sign = 0
            homeTableView.rowHeight = 250
            self.homeTableView.reloadData()
        case 1:
            sign = 1
             homeTableView.rowHeight = 50
            self.homeTableView.reloadData()
        default:
            break
        }
    }
    
    
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sign == 0 {
           return self.sectionEvents [section]
        }
        else{
            return self.sectionTasks [section]
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sign == 0 {
            return self.sectionEvents.count
        }
        else{
            return self.sectionTasks.count
        }
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sign == 0 {
            if section == 0 {
                return upcomingEventList.count
            }
            else {
                return pastEventList.count
            }
        }
        else{
            return tasksList[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if sign == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeEventTableViewCell") as! HomeEventTableViewCell
            let currSection = sectionEvents[indexPath.section]
            switch currSection {
                
            case "Upcoming" :
                cell.event = upcomingEventList[indexPath.item]
                break;
                
            case "Past":
                cell.event = pastEventList[indexPath.item]
                break;
            
            default:
                break;
            }
            return cell
        
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTaskTableViewCell") as! HomeTaskTableViewCell
            var tasks = tasksList[indexPath.section]
            cell.task = tasks[indexPath.item]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Perform Segue ShowDetails
        if sign == 0{
           homeTableView.deselectRow(at:indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier?.isEqual("showEvent"))! {
        if sign == 0{
            let indexPath = homeTableView.indexPathForSelectedRow
           
            let section = indexPath?.section
            let event : Event
            if section == 0 {
                event = upcomingEventList[(indexPath?.row)!]
            }
            else{
                event = pastEventList[(indexPath?.row)!]
            }
            let eventViewController = segue.destination as! EventViewController
            eventViewController.event = event
          }
        }
        
        else if (segue.identifier?.isEqual("mapSegue"))!  {
            let mapViewController = segue.destination as! EventsMapViewController
            mapViewController.events = upcomingEventList
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchEvents(){
        
        /*-----Get past events ----*/

        OldEventApi.sharedInstance.getPastEventsHostedByUserEmail(userEmail: (User._currentUser?.email)!, success: { (events: [Event]) in
            if events.count > 0 {
                for i in 0...events.count-1{
                    events[i].hostProfileImage = User.currentUser?.imageUrl
                    self.pastEventList.append(events[i])
                }
            }
        }, failure: {} )
        
        //TODO: Need to get host profile
        OldEventApi.sharedInstance.getPastEventsForUserEmail(userEmail: (User._currentUser?.email)!, success: { (events: [Event]) in
            if events.count > 0 {
                for i in 0...events.count-1{
                    self.pastEventList.append(events[i])
                }
            }
            self.homeTableView.reloadData()
        }, failure: {} )
       
        
        /*-----Get upcoming events ----*/
        
        OldEventApi.sharedInstance.getUpcomingEventsHostedByUserEmail(userEmail: (User._currentUser?.email)!, success: { (events: [Event]) in
            if events.count > 0 {
                for i in 0...events.count-1{
                    events[i].hostProfileImage = User.currentUser?.imageUrl
                    self.upcomingEventList.append(events[i])
                }
            }
        }, failure: {} )
        
        //TODO: Need to get host profile
        OldEventApi.sharedInstance.getUpcomingEventsForUserEmail(userEmail: (User._currentUser?.email)!, success: { (events: [Event]) in
            if events.count > 0 {
                for i in 0...events.count-1{
                    self.upcomingEventList.append(events[i])
                }
            }
            self.homeTableView.reloadData()
            self.fetchTasks()
            
        }, failure: {} )
        
   
    }
    
    
    func fetchTasks(){
        
        for event in upcomingEventList {
            TaskApi.sharedInstance.getTasksByEventId(eventId: event.id, success: {(tasks: [Task])
                in
                for task in tasks {
                    if (task.volunteerEmails?.contains((User._currentUser?.email)!))! {
                        task.eventName = event.name
                        self.taskList.append(task)
                        print(task.name)
                        self.homeTableView.reloadData()
                        if !self.sectionTasks.contains(event.name!){
                            self.sectionTasks.append(event.name!)
                        }
                    }
                }
                self.tasksList.append(self.taskList)
                self.taskList = [Task]()
               
                
                }, failure:{})
        
        }
    }
    

}
