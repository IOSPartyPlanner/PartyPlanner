//
//  HomeViewController.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{

  @IBAction func onSignout(_ sender: Any) {
    User.currentUser?.signout()
  }
    
    @IBOutlet var homeSegmentedControl: UISegmentedControl!
    @IBOutlet var homeTableView: UITableView!
    var pastEventList = [Event]()
    var upcomingEventList = [Event]()
    var taskList = [Task]()
    var sectionEvents = ["Upcoming", "Past"]
    var sectionTasks = ["House Warming Party", "House Warming Party"] //[String]() //TODO:
    var sign = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchEvents()
        
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
    
        //TODO:Will change
        else{
            if section == 0{
                return 3
            }
            else {
                return 2
            }
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
            
        return cell
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchEvents(){
        
        /*-----Get past events ----*/

        EventApi.sharedInstance.getPastEventsHostedByUserEmail(userEmail: (User._currentUser?.email)!, success: { (events: [Event]) in
            if events.count > 0 {
                for i in 0...events.count-1{
                    events[i].hostProfileImage = User.currentUser?.imageUrl
                    self.pastEventList.append(events[i])
                }
            }
        }, failure: {} )
        
        //TODO: Need to get host profile
        EventApi.sharedInstance.getPastEventsForUserEmail(userEmail: (User._currentUser?.email)!, success: { (events: [Event]) in
            if events.count > 0 {
                for i in 0...events.count-1{
                    self.pastEventList.append(events[i])
                }
            }
            self.homeTableView.reloadData()
        }, failure: {} )
       
        
        /*-----Get upcoming events ----*/
        
        EventApi.sharedInstance.getUpcomingEventsHostedByUserEmail(userEmail: (User._currentUser?.email)!, success: { (events: [Event]) in
            if events.count > 0 {
                for i in 0...events.count-1{
                    events[i].hostProfileImage = User.currentUser?.imageUrl
                    self.upcomingEventList.append(events[i])
                }
            }
        }, failure: {} )
        
        //TODO: Need to get host profile
        EventApi.sharedInstance.getUpcomingEventsForUserEmail(userEmail: (User._currentUser?.email)!, success: { (events: [Event]) in
            if events.count > 0 {
                for i in 0...events.count-1{
                    self.upcomingEventList.append(events[i])
                }
            }
            self.homeTableView.reloadData()
            
        }, failure: {} )
    }
    
    func fetchTasks(){
        //TODO: Needed API function
      
    }

}
