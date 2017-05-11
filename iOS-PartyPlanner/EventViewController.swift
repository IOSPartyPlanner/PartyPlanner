//
//  EventViewController.swift
//  iOS-PartyPlanner
//
//  Created by Yan, Tristan on 4/25/17.
//  Copyright © 2017 PartyDevs. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBAction func onSignout(_ sender: UIBarButtonItem) {
        User.currentUser?.signout()
    }
    
    @IBOutlet weak var eventTableView: UITableView!
  
    var event: Event?
    
    var guestsCell: EventGuestsTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventTableView.delegate = self
        eventTableView.dataSource = self
        
        eventTableView.rowHeight = UITableViewAutomaticDimension
        eventTableView.estimatedRowHeight = 120
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            case "ShowPhotos":
                let target =  segue.destination as? PhotoBrowserViewController
                target?.photosURL = (event?.postEventPhotoesURL)!
            case "addPhoto":
                break
            case "addTask":
                break
            case "addComment":
                break
            default:
                break
        }
    }
}

extension EventViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if (event?.isPast())! || (event?.isUserOnwer())! {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
        default:
            if (event?.isPast())! {
                return event?.postComments.count ?? 0
            } else {
                return event?.tasks.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (event?.isUserOnwer())! {
            if section == 1 {
                return "Guests"
            } else {
                return "Tasks"
            }
        } else {
            if section == 1 {
                return "Media"
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, (event?.isUserOnwer())!) {
        case (0, _):
            let cell0 = eventTableView.dequeueReusableCell(withIdentifier: "EventSummaryTableViewCell", for: indexPath) as? EventSummaryTableViewCell
            cell0?.event = event
            return cell0!
        case (1, true):
            guestsCell = eventTableView.dequeueReusableCell(withIdentifier: "EventGuestsTableViewCell", for: indexPath) as? EventGuestsTableViewCell
            guestsCell?.guests = event?.guests
            guestsCell?.viewController = self
            return guestsCell!
        case (1, false):
            let cell1 = eventTableView.dequeueReusableCell(withIdentifier: "PhotoesTableViewCell", for: indexPath) as? PhotoesTableViewCell
            cell1?.photoes = event?.postEventImages
            cell1?.viewController = self
            return cell1!
        case (2, true):
            let cell2 = eventTableView.dequeueReusableCell(withIdentifier: "EventTasksTableViewCell", for: indexPath) as? EventTasksTableViewCell
//            cell2?.photoes = event?.postEventImages
//            cell1?.viewController = self
            return cell2!
        default:
            let cell2 = eventTableView.dequeueReusableCell(withIdentifier: "EventGuestCommentTableViewCell", for: indexPath) as? EventGuestCommentTableViewCell
            if let userComment = event?.postComments[indexPath.row] {
                cell2?.comment = userComment
            }
            return cell2!
        }

    }
}
